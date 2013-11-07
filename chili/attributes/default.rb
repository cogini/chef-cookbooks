default[:chili][:dependencies] = %w{
    libmagickwand-dev
    rubygems
}
default[:chili][:required_gems] = %w{
    unicorn
}

default[:chili][:app_user] = "chili"
default[:chili][:site_dir] = "/home/chili/chili"
default[:chili][:log_dir] = "/home/chili/chili/log"
default[:chili][:temp_dir] = "/home/chili/chili/tmp"
default[:chili][:db][:database] = "chili"
default[:chili][:db][:host] = "localhost"
default[:chili][:db][:user] = "chili"
default[:chili][:version] = "v3.8.0"
default[:chili][:worker_processes] = 2
