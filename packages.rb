package :python_software_properties do
  apt 'python-software-properties'
  verify do
    has_apt 'python-software-properties'
  end
end

package :ppa do
  description 'support for ppa repositories'
  requires :python_software_properties
  verify do
    has_executable 'apt-add-repository'
  end
end

package :build_essential do
  apt 'build-essential' do
    pre :install, 'apt-get update'
  end
  verify do
    has_apt 'build-essential'
  end
end

# webserver
package :nginx, provides: :webserver do
  description 'install latest Nginx from ppa repository'
  requires :ppa
  apt 'nginx-full' do
    pre :install, "apt-add-repository ppa:nginx/stable"
    pre :install, "apt-get update"
  end
  verify do
    has_apt 'nginx-full'
    has_user 'www-data'
    has_process 'nginx'
  end
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
  requires :build_essentials
  source "http://download.redis.io/redis-stable.tar.gz" do
    pre :install, "killall -9 redis-server || true"
    custom_install 'make install'
  end
  verify do
    has_executable 'redis-server'
    #has_executable_with_version('redis-server', '2.1.10', '--version')
  end
end

policy :base, roles: :base do
  requires :build_essential
end

policy :rails, roles: :app do
  requires :webserver
  requires :database
end
