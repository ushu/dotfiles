# Use Markdown for the TODO
git :init
create_file '.ruby-version', '2.0'

remove_file 'README.rdoc'
create_file 'README.md', 'A rails App :)'

def render_template(source,options=binding())
  ERB.new(source).result(options)
end

use_carrierwave = yes? 'use carrierwave ?'
use_omniauth = yes? 'use omniauth ?'
if use_omniauth
  while true
    omniauth = ask('th (enter space-separated strategies, empty for none)').strip
    strategies = omniauth.split(' ').collect {|s| s.strip.gsub('-','_')}.select {|s| !s.empty? }
    unless strategies.empty?
      # auto convert google to google-oauth2
      omniauth_strategies = strategies.collect {|s| (s == 'google') ? 'google_oauth2' : s}
      break
    end
  end

  # generate initializers
  omniauth_strategies.each do |s|
    omniauth_template = <<-EOF
Rails.application.config.middleware.use OmniAuth::Builder do
<% omniauth_strategies.each do |s| %>
  provider :#{s}, ENV['#{s.upcase}_KEY'], ENV['#{s.upcase}_SECRET']
<% end %>
end
EOF
    omniauth_conf = render_template(omniauth_template, binding)
    create_file 'config/initializers/omniauth.rb', omniauth_conf
  end
end

use_heroku = yes? 'prepare for Heroku deployment ?'
if use_heroku
  heroku_app_name = ask('Name for the heroku app (leave empty to skip creation) ?').strip
end

use_sendgrid = yes? 'use sendgrid for mail delivery ?'

gemfile_template =  <<-EOF
source 'https://rubygems.org'

gem 'rails', '4.0.2'

# css
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'autoprefixer-rails'

# js
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'

# views
gem 'jbuilder', '~> 1.2'
# gem 'simpleform'

# models
# gem 'bcrypt-ruby', '~> 3.1.2'
# gem 'email_validator'
# gem 'date_validator'
<% if use_omniauth %>
# Omniauth providers
<% omniauth_strategies.each do |s| %>gem "omniauth-<%= s.gsub('_','-') %>"<% end %>
<% end %><% if use_carrierwave %>
# Carrierwave
gem 'carrierwave'
gem 'mime-types'
gem 'rmagick'
# # for AWS
gem 'unf'
gem 'fog'
<% end %>
# doc
#group :doc do
#  # bundle exec rake doc:rails generates the API under doc/api.
#  gem 'sdoc', require: false
#end

# dev/test
group :development do
  gem 'figaro'
  gem 'jazz_hands' # better pry support
  gem 'zeus'
  # generate source maps
  gem 'coffee-rails-source-maps'
  gem 'sass-rails-source-maps'
  # random stuff
  # gem 'better_errors' # better error pages
  # gem 'annotate' # generate attribute list in model file
  # gem 'bullet' # profile db calls
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  # RSpec
  gem 'rspec-rails'
  gem 'shoulda-matchers' # test model validations
  # capybara stuff
  gem 'cucumber-rails', require: false
  gem 'selenium-webdriver' # headless
  gem 'launchy' # enable save_and_open_page
end

# Deployment
gem 'capistrano', group: :development
group :development, :test do
  gem 'thin'
  gem 'sqlite3'
end

# db
group :production do
  gem 'pg'
  gem 'unicorn'
  <% if use_heroku %>gem 'rails_12factor' # better heroku integration<% end %>
end
EOF
gemfile_source = render_template(gemfile_template, binding)

remove_file 'Gemfile'
create_file 'Gemfile', gemfile_source

run 'bundle install'

generate 'rspec:install'
generate 'cucumber:install'
generate 'figaro:install'

# empty figaro default file
remove_file 'config/application.yml'
create_file 'config/application.yml'
# populate
if use_omniauth
  # generate initializers
  omniauth_strategies.each do |s|
    append_file 'config/application.yml', "#{s.upcase}_KEY:\n"
    append_file 'config/application.yml', "#{s.upcase}_SECRET:\n"
  end
end

comment_lines "spec/spec_helper.rb", /rspec\/autorun/
insert_into_file "spec/spec_helper.rb", :after => "RSpec.configure do |config|\n" do
  <<-EOF
  # Configure Database Cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

EOF
end

create_file 'config/unicorn.rb', <<-UNICORN
    # from https://devcenter.heroku.com/articles/rails-unicorn
    worker_processes Integer(ENV["WEB_CONCURRENCY"] || 4)
    timeout 30
    preload_app true

    before_fork do |server, worker|
      Signal.trap 'TERM' do
        puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
        Process.kill 'QUIT', Process.pid
      end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
    end

    after_fork do |server, worker|
      Signal.trap 'TERM' do
        puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
      end

      defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
    end
UNICORN
append_file 'config/application.yml', "WEB_CONCURRENCY:\n"
create_file 'Procfile', 'web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb'

if use_carrierwave
  create_file 'config/initializers/carrierwave.rb', <<-EOF
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV['AWS_SECRET_KEY_ID'],
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    :region                 => 'eu-west-1' # ireland
  }
  config.fog_directory  = ENV['AWS_S3_BUCKET']
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end
EOF
  append_file 'config/application.yml', "AWS_S3_BUCKET:\n"
  append_file 'config/application.yml', "AWS_SECRET_KEY_ID:\n"
  append_file 'config/application.yml', "AWS_SECRET_ACCESS_KEY:\n"
end

create_file 'config/initializers/mail.rb'
if use_sendgrid
  append_file 'config/initializers/mail.rb', <<-EOF
ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_USER'],
  :password => ENV['SENDGRID_PASSWORD'],
  :domain => 'herokuapp.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

EOF
  append_file 'config/application.yml', "SENDGRID_USER:\n"
  append_file 'config/application.yml', "SENDGRID_PASSWORD:\n"
end

# setup mail interceptor
create_file 'lib/development_mail_interceptor.rb', <<-EOF
# idea from RailsCasts, super userful !
class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "\#{message.to} \#{message.subject}"
    message.to = ENV['DEVELOPMENT_REDIRECT_EMAIL']
  end
end
EOF
append_file 'config/application.yml', "DEVELOPMENT_REDIRECT_EMAIL:\n"

append_file 'config/initializers/mail.rb', <<-EOF
ActionMailer::Base.default_url_options[:host] = "localhost:3000" unless Rails.env.production?

if Rails.env.development?
  require 'development_mail_interceptor'
  Mail.register_interceptor(DevelopmentMailInterceptor)
end
EOF

if use_heroku && heroku_app_name.empty?
  run "heroku create #{heroku_app_name}"
end

git add: ".", commit: "-m 'Initial commit'"
