require 'thor'

class SprinkleInit < Thor
  include Thor::Actions

  desc 'init', 'create deploy.rb and package.rb for sprinkle'
  def init
    if yes? 'deploy to vagrant box (yes/no)?'

      create_file 'deploy.rb', <<-END
require './packages.rb'

policy :basic_server, roles: :webserver  do
  requires :base
  requires :webserver
  requires :database
  requires :cache
  requires :firewall
end

deployment do
  delivery :capistrano do
    role :webserver, "127.0.0.1"

    set :user, "vagrant"
    set :run_method, :sudo
    ssh_options[:keys] = ["\#{ENV['HOME']}/.vagrant.d/insecure_private_key"]
    ssh_options[:port] = 2222
  end

  source do
    prefix   '/usr/local'           # where all source packages will be configured to install
    archives '/usr/local/sources'   # where all source packages will be downloaded to
    builds   '/usr/local/build'     # where all source packages will be built
  end
end
      END
    else
      create_file 'deploy.rb', <<-END
# TODO: set node ip/hostname
$node = '127.0.0.1'
# TODO: set user with distant account
$remote_user = 'deploy'

require './packages.rb'

policy :web_frontend, roles: :rails_server  do
  requires :base
  requires :nginx # or :apache
end

policy :data_stores, roles: :rails_server  do
  requires :postgresql # or mysql
  requires :redis # or memcached
end

deployment do
  delivery :capistrano do
    role :rails_server, $node
    set :run_method, :sudo
  end

  source do
    prefix   '/usr/local'           # where all source packages will be configured to install
    archives '/usr/local/sources'   # where all source packages will be downloaded to
    builds   '/usr/local/build'     # where all source packages will be built
  end
end
      END
    end
    copy_file 'packages.rb'
  end
end

SprinkleInit.source_root(File.expand_path("~/.dotfiles"))
SprinkleInit.start(ARGV)
