require File.join(File.dirname(__FILE__),'packages.rb')

deployment do
  delivery :capistrano do
    role :base, "127.0.0.1"
    role :app, "127.0.0.1"
    set :user, "vagrant"
    set :run_method, :sudo
    ssh_options[:keys] = ["#{ENV['HOME']}/.vagrant.d/insecure_private_key"]
    ssh_options[:port] = 2222
  end
end

