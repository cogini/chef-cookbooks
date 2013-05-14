# Required dependencies
set[:gitlab][:dependencies] = %w{
  checkinstall
  curl
  libcurl4-openssl-dev
  libffi-dev
  libgdbm-dev
  libicu-dev
  libncurses5-dev
  libreadline-dev
  libssl-dev
  libxml2-dev
  libxslt-dev
  libyaml-dev
  openssh-server
  redis-server
  ruby1.9.1-dev
  ruby1.9.3
  zlib1g-dev
}


default[:gitlab][:version] = "5-1-stable"

default[:gitlab][:dbHost] = "localhost"
default[:gitlab][:dbName] = "gitlab_production"
default[:gitlab][:dbUsername] = "gitlab"

# Users info
default[:gitlab][:git_user][:name] = "git"
default[:gitlab][:git_user][:shell] = "/bin/bash"
default[:gitlab][:git_user][:home] = "/home/git"

default[:gitlab][:gitlab_shell][:dir] = "/home/git/gitlab-shell"
default[:gitlab][:gitlab_shell][:version] = "v1.3.0"

default[:gitlab][:dir] = "/home/git/gitlab"

default[:gitlab][:ssh_port] = 22

default[:gitlab][:host] = "localhost"
default[:gitlab][:port] = 80
