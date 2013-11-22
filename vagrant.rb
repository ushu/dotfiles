require File.join(File.dirname(__FILE__),'packages.rb')

policy :rails, roles: :rails do
  requires :rails_stack, app_name: 'toto'
end

deployment do
  delivery :capistrano do
    role :rails, "127.0.0.1"

    set :user, "vagrant"
    set :run_method, :sudo
    ssh_options[:keys] = ["#{ENV['HOME']}/.vagrant.d/insecure_private_key"]
    ssh_options[:port] = 2222
  end

  source do
    prefix   '/usr/local'           # where all source packages will be configured to install
    archives '/usr/local/sources'   # where all source packages will be downloaded to
    builds   '/usr/local/build'     # where all source packages will be built
  end
end

