require 'set'

$users ||= Set.new

# utilities
package :apt_update do
  description 'Update apt cache'
  runner 'apt-get update'
end

package :python_software_properties do
  apt 'python-software-properties'
  verify do
    has_apt 'python-software-properties'
  end
end

package :ppa do
  description 'support for ppa repositories with apt-add-repository'
  requires :python_software_properties
  verify do
    has_executable 'apt-add-repository'
  end
end

package :build_essential do
  apt 'build-essential'
  verify do
    has_apt 'build-essential'
  end
end

package :ssh do
  description 'OpsnSSH client and daemon'
  apt %w{openssh-client openssh-server}
  verify do
    %w{sshd ssh}.each { |e| has_executable e }
    has_process 'sshd'
  end
end

package :update_locales, sudo: true do
  apt %w{en fr}.collect { |l| "language-pack-#{l}" } do
    post :install, 'locale-gen'
    post :install, 'update-locale LANGUAGE=en_US.UTF8 LC_MESSAGES=POSIX'
    post :install, 'dpkg-reconfigure locales'
  end
end

# create users
package :user do
  add_user opts[:name], in_group: opts[:name], flags: "--disabled-password"
  verify do
    has_user opts[:name], in_group: opts[:name]
  end
end

# scm
package :git, provides: :scm do
  apt 'git-core'
  verify do
    has_apt 'git'
    has_executable 'git'
  end
end

# firewall
package :ufw_add_profile do
  requires :ufw
  runner "ufw allow \"#{opts[:profile]}\""
  verify do
    runs_without_error "ufw status | grep \"#{opts[:profile]}\""
  end
end

package :ufw, provides: :firewall do
  apt 'ufw'
  runner 'ufw default deny'
  runner 'ufw allow OpenSSH'
  runner  'ufw --force enable'

  verify do
    has_executable 'ufw'
    runs_without_error 'ufw status | grep "Status: active"'
    runs_without_error 'ufw status | grep "OpenSSH"'
  end
end

# security packages
package :fail2ban do
  requires :ssh
  apt 'fail2ban'
  verify do
    has_apt 'fail2ban'
  end
end

package :ssh_hardening do
  key = File.read(File.expand_path('~/.ssh/id_rsa.pub')).chomp

  push_text key, '~/.ssh/authorized_keys'
  replace_text 'PasswordAuthentication yes', 'PasswordAuthentication no', '/etc/ssh/sshd_config'
  replace_text 'X11Forwarding yes', 'X11Forwarding no', '/etc/ssh/sshd_config'
  replace_text 'UsePAM yes', 'UsePAM no', '/etc/ssh/sshd_config'
  verify do
    file_contains '~/.ssh/authorized_keys', key
    file_contains '/etc/ssh/sshd_config', 'PasswordAuthentication no'
    file_contains '/etc/ssh/sshd_config', 'X11Forwarding no'
    file_contains '/etc/ssh/sshd_config', 'UsePAM no'
  end
end

# webserver
package :nginx_ppa, provides: :webserver do
  description 'install latest Nginx from ppa repository'
  requires :ppa
  apt 'nginx-full' do
    pre :install, "apt-add-repository ppa:nginx/stable"
    pre :install, "apt-get update"
    post :install, 'update-rc.d nginx defaults'
  end
  verify do
    has_apt 'nginx-full'
    has_user 'www-data'
    has_executable 'nginx'
  end
end
package :nginx, provides: :webserver do
  description 'install latest Nginx'
  requires :nginx_ppa
  requires :ufw_add_profile, profile: 'Nginx Full'
end

package :apache, provides: :webserver do
  description 'install Apached httpd from apt'
  apt 'apache2'
  verify do
    has_apt 'apache2'
    has_user 'www-data'
  end
end

# database
package :postgresql, provides: :database do
  description 'install latest PostgreSQL'
  file '/etc/apt/sources.list.d/pgdg.list', content: 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main', sudo: true
  apt 'postgresql' do
    pre :install, 'wget https://www.postgresql.org/media/keys/ACCC4CF8.asc; apt-key add ACCC4CF8.asc; rm ACCC4CF8.asc'
    pre :install, 'apt-get update'
  end
  verify do
    has_apt 'postgresql'
    has_user 'postgres'
    has_process 'postgres'
  end
end

package :mysql, provides: :database do
  description 'install MySQL using apt'
  apt 'mysql-server'
  verify do
    has_apt 'mysql-server'
    has_user 'mysql'
  end
end

# cache
package :redis, provides: :cache do
  description 'install Redis using apt'
  apt 'redis-server'
  verify do
    has_apt 'redis-server'
    has_executable 'redis-server'
  end
end

package :memcached, provides: :cache do
  description 'install Memcache using apt'
  apt 'memcached'
  verify do
    has_apt 'memcached'
    has_executable 'memcached'
  end
end

# meta packages
package :base_tools do
  description 'install base tools for box administration'
  %w{scm ssh}.each { |d| requires d }
  apt %w{wget curl vim-nox}
  verify do
    %w{wget curl vim}.each { |e| has_executable e }
  end
end

package :base_security do
  requires :fail2ban
  requires :ssh_hardening
  requires :firewall
end

package :base do
  description 'Stuff I install on all servers'
  # check environment
  requires :apt_update
  requires :update_locales
  # install vim, git ...
  requires :base_tools
  # basic node security tools
  requires :base_security
end

package :rails_stack do
  requires :base
  requires :nginx
  requires :postgresql
  requires :redis

  app = opts[:app_name]
  requires :user, name: app
  runner "mkdir /home/#{app}/app"
  runner "chown -R #{app} /home/#{app}/app"
end
