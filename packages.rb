require 'set'

$locales = %w{en fr}
$ufw_profiles = [ 'Nginx Full' ]

# utilities
package :apt_update do
  description 'Update apt cache'
  runner 'apt-get update'
end

%w{python-software-properties
build-essential
git-core
ufw
fail2ban
}.each do |p|
  description "install #{p}"
  package p do
    apt p
    verify { has_apt p }
  end
end

package :fix_locales do
  description "fix locales (buggy by default if not US)"
  apt $locales.collect { |l| "language-pack-#{l}" } do
    post :install, 'locale-gen'
    post :install, 'update-locale LANGUAGE=en_US.UTF8 LC_MESSAGES=POSIX'
    post :install, 'dpkg-reconfigure locales'
  end
end

# create users
package :user do
  description "create a user with a group of the same name"
  add_user opts[:name], in_group: opts[:name], flags: "--disabled-password"
  verify { has_user opts[:name], in_group: opts[:name] }
end

# firewall
package :ufw, provides: :firewall do
  requires 'ufw'
  runner 'ufw default deny'
  runner 'ufw allow OpenSSH'
  runner  'ufw --force enable'

  verify do
    has_executable 'ufw'
    runs_without_error 'ufw status | grep "Status: active"'
    runs_without_error 'ufw status | grep "OpenSSH"'
  end
end

package :ufw_add_profile do
  requires :ufw
  runner "ufw allow \"#{opts[:profile]}\""
  verify { runs_without_error "ufw status | grep \"#{opts[:profile]}\"" }
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
package :nginx_repo do
  description 'install repository'
  requires 'python-software-properties'

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
  description 'install latest Nginx from ppa repository'
  requires 'python-software-properties'

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

# database
package :postgresql_repository do
  description 'install official PostgreSQL repository and keys'

  file '/etc/apt/sources.list.d/pgdg.list', content: 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main'
  runner 'wget https://www.postgresql.org/media/keys/ACCC4CF8.asc; apt-key add ACCC4CF8.asc; rm ACCC4CF8.asc'
  runner 'apt-get update'
  verify do
    has_file '/etc/apt/sources.list.d/pgdg.list'
  end
end

package :postgresql, provides: :database do
  description 'install latest PostgreSQL'
  requires :postgresql_repository
  apt 'postgresql'
  verify do
    has_apt 'postgresql'
    has_user 'postgres'
    has_process 'postgres'
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
