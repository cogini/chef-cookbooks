# Required dependencies
default[:gitlab][:dependencies] = %w{ sudo build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server redis-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev ruby1.9.3 python vim nginx }

# Users info
default[:user][:git][:name] = "git"
default[:user][:git][:shell] = "/bin/bash"
default[:user][:git][:home] = "/home/git"

default[:user][:gitlab][:name] = "gitlab"
default[:user][:gitlab][:shell] = "/bin/bash"
default[:user][:gitlab][:home] = "/home/gitlab"

default[:user][:group] = "git"
