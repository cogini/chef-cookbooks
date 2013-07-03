set[:amanda][:app_user] = 'amandabackup'
set[:amanda][:app_group] = 'disk'

# 'backup_locations': [
#   {
#     'hostname' : 'localhost',
#     'ip'       : '123.123.123.123',
#     'port'     : '1234',
#     'locations': [
#       '/etc',
#       '/var/www'
#     ]
#   }
# ]
default[:amanda][:backup_locations] = []

default[:amanda][:cron_time] = 0
default[:amanda][:dumpcycle_daily] = '7 days'
default[:amanda][:dumpcycle_monthly] = '12 weeks'
default[:amanda][:dumpcycle_weekly] = '4 weeks'
default[:amanda][:home] = '/var/lib/amanda'
default[:amanda][:runtapes] = nil
default[:amanda][:tapecycle] = 10
default[:amanda][:version] = '3.3.3'

default[:amanda][:dir][:holding_dir] = '/srv/amanda/holding'
default[:amanda][:dir][:index_dir] = '/srv/amanda/state/index'
default[:amanda][:dir][:info_dir] = '/srv/amanda/state/curinfo'
default[:amanda][:dir][:log_dir] = '/srv/amanda/state/log'
default[:amanda][:dir][:vtapes_dir] = '/srv/amanda/vtapes'
