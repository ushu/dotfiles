# Use Markdown for the TODO
remove_file 'README.rdoc'
create_file 'README.md', 'TODO'

gem 'rspec-rails', group: [:test, :development]
gem 'cucumber-rails', require: false, group: [:test, :development]
gem 'database_cleaner'
gem 'factory_girl_rails'
gem 'figaro'
gem 'rails-boilerplate'

run 'bundle install'

generate 'rspec:install'
generate 'cucumber:install'
generate 'figaro:install'
generate 'boilerplate:install', '-f'

# empty figaro default file
remove_file 'config/application.yml'
create_file 'config/application.yml'

insert_into_file "spec/spec_helper.rb", :after => "RSpec.configure do |config|\n" do
  <<-CONF
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

  CONF
end

if yes? 'use omniauth ?'
  while true
    omniauth = ask('th (enter space-separated strategies, empty for none)').strip
    strategies = omniauth.split(' ').collect {|s| s.strip.gsub('-','_')}.select {|s| !s.empty? }
    unless strategies.empty?
      # auto convert google to google-oauth2
      strategies = strategies.collect {|s| (s == 'google') ? 'google_oauth2' : s}

      strategies.each do |s|
        gem "omniauth-#{s.gsub('_','-')}"
      end
      run 'bundle install'

      initializer = [ 'Rails.application.config.middleware.use OmniAuth::Builder do' ]
      strategies.each do |s|
        initializer << "provider :#{s}, ENV['#{s.upcase}_KEY'], ENV['#{s.upcase}_SECRET']"
      end
      initializer << 'end'
      create_file 'config/initializers/omniauth.rb', initializer.join("\n")

      strategies.each do |s|
        append_file 'config/application.yml', "#{s.upcase}_KEY:"
        append_file 'config/application.yml', "#{s.upcase}_SECRET:"
      end

      break
    end
  end
end

# configure application containers
#  use unicorn for production
gem 'unicorn', group: :production
create_file 'config/unicorn.rb', <<-UNICORN
    # from https://devcenter.heroku.com/articles/rails-unicorn
    worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
    timeout 15
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
append_file 'config/application.yml', 'WEB_CONCURRENCY:'
create_file 'Procfile', 'web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb'
# use Thin for development
gem 'thin', group: [:development, :test]

# Ask for heroku support
use_heroku = yes? 'use Heroku for deployment ?'
if use_heroku
  gem 'sqlite3', group: [:development, :test]
  gem 'pg', group: :production
  gem 'rails_12factor', group: :production
end

run 'bundle install'

git :init
use_git_flow = yes? 'Use Git-Flow ?'
if use_git_flow
  run 'git flow init -d'
  git add: ".", commit: "-m 'Initial Rails project'"
else
  git add: ".", commit: "-m 'Initial commit'"
end

if use_heroku
  app_name = ask('Name for the heroku app ? (leave empty to skip)').strip
  unless app_name.empty?
    run "heroku create #{app_name}"

    if yes? 'Push to heroku ?'
      branch = use_git_flow ? 'develop' : 'master'
      git push: "heroku #{branch}:master"
    end
  end
end
