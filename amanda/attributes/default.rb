default[:amanda][:dependencies] = %w{
  gettext
  heirloom-mailx
  libcroco3
  libcurl3
  libfile-copy-recursive-perl
  libgettextpo0
  libunistring0
  update-inetd
  xinetd
}


default[:amanda][:type] = "client"
default[:amanda][:version] = "3.3.3"
default[:amanda][:app_user] = "amandabackup"

# backup_locations
#   hostname
#   ip
#   location []
default[:amanda][:backup_locations] = []

default[:amanda][:dir][:backup_dir] = "/amanda"
default[:amanda][:dir][:holding_dir] = "/amanda/holding"
default[:amanda][:dir][:index_dir] = "/amanda/state/index"
default[:amanda][:dir][:info_dir] = "/amanda/state/curinfo"
default[:amanda][:dir][:log_dir] = "/amanda/state/log"
default[:amanda][:dir][:vtapes_dir] = "/amanda/vtapes"

default[:amanda][:tapecycle] = 15
default[:amanda][:dumpcycle] = 7

default[:amanda][:key_dir] = "/var/lib/amanda/.ssh"

