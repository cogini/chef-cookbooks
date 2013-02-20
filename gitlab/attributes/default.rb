# Required dependencies
set[:gitlab][:dependencies] = %w{ sudo build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev openssh-server redis-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev ruby1.9.3 }

# Users info
default[:gitlab][:git_user][:name] = "git"
default[:gitlab][:git_user][:shell] = "/bin/bash"
default[:gitlab][:git_user][:home] = "/home/git"

default[:gitlab][:gitlab_user][:name] = "gitlab"
default[:gitlab][:gitlab_user][:shell] = "/bin/bash"
default[:gitlab][:gitlab_user][:home] = "/home/gitlab"

default[:gitlab][:group] = "git"

default[:gitlab][:dir] = "/home/gitlab/gitlab"

set[:gitlab][:dbName] = "gitlab_production"
set[:gitlab][:dbUsername] = "gitlab"
set[:gitlab][:dbPassword] = "gitlab"

default[:gitlab][:ssh_host] = "localhost"
default[:gitlab][:ssh_port] = "22"

default[:gitlab][:host] = "localhost"
default[:gitlab][:port] = "80"
