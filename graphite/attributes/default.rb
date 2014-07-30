default[:graphite][:db][:engine] = 'sqlite3'
default[:graphite][:db][:host] = 'localhost'
default[:graphite][:db][:name] = '/var/lib/graphite/graphite.db'
default[:graphite][:users] = {}
default[:graphite][:auth_user_file] = '/etc/apache2/graphite.passwd'

# {
#     "graphite": {
#         "storage_schemas": {
#             "bounce": {
#                 "pattern": "collectd-powder.bounce",
#                 "retentions": "10s:7d"
#             }
#         }
#     }
# }
default[:graphite][:storage_schemas] = {}
