default[:chili][:dependencies] = %w{
    libmagickwand-dev
    rubygems
}

default[:chili][:required_gems] = %w{
    unicorn
}

default[:chili][:app_user] = "chili"

default[:chili][:db][:adapter] = "postgresql"
default[:chili][:db][:database] = "chili"
default[:chili][:db][:host] = "localhost"
default[:chili][:db][:user] = "chili"

default[:chili][:log_dir] = "/home/chili/chili/log"
default[:chili][:site_dir] = "/home/chili/chili"
default[:chili][:temp_dir] = "/home/chili/chili/tmp"

default[:chili][:web_server] = "nginx"
default[:chili][:unicorn_port] = "8700"

default[:chili][:site_name] = "chili"

default[:chili][:version] = "v3.8.0"
