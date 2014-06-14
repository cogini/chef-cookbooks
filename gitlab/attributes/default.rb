# Required dependencies
set[:gitlab][:dependencies] = %w{
  curl
  libcurl4-openssl-dev
  libffi-dev
  libgdbm-dev
  libicu-dev
  libncurses5-dev
  libreadline-dev
  libssl-dev
  libxml2-dev
  libxslt1-dev
  libyaml-dev
  python-docutils
  redis-server
  ruby1.9.1-dev
  ruby1.9.3
  zlib1g-dev
}

default[:gitlab][:version] = "v6.7.3"

default[:gitlab][:dbHost] = "localhost"
default[:gitlab][:dbName] = "gitlab_production"
default[:gitlab][:dbUsername] = "gitlab"

# Users info
default[:gitlab][:git_user][:name] = "git"
default[:gitlab][:git_user][:shell] = "/bin/bash"
default[:gitlab][:git_user][:home] = "/home/git"

# XXX gitlab-shell dir is hardcoded in some files, so if you want to move it to
# another location, remember to create a symlink to /home/git/gitlab-shell
default[:gitlab][:shell][:dir] = "/home/git/gitlab-shell"
default[:gitlab][:shell][:version] = "v1.9.1"

default[:gitlab][:dir] = "/home/git/gitlab"

default[:gitlab][:ssh_port] = 22

default[:gitlab][:host] = "localhost"
default[:gitlab][:enable_https] = false

default[:gitlab][:satellites_path] = "/home/git/gitlab-satellites/"
default[:gitlab][:repos_path] = "/home/git/repositories/"

default[:gitlab][:worker_processes] = 2


if node[:gitlab][:enable_https]
    default[:gitlab][:port] = 443
else
    default[:gitlab][:port] = 80
end
