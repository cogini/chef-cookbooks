# Json format:
# "shorewall": {
#   "allowed_connections": [
#     {
#       "hosts": ["ip1", "ip2"],
#       "ports": ["port1", "port2"]
#     },
#     {
#       ...
#     }
#   ]
# }
default[:shorewall][:allowed_connections] = []

default[:shorewall][:allowed_services] = %w{ http https ssh }
