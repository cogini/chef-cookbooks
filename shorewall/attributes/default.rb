default[:shorewall][:allowed_ports] = [
    22,
    80,
    443,
]
default[:shorewall][:blocked_ports] = []
default[:shorewall][:allowed_hosts] = []

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
default[:shorewall][:allowed_services] = []
default[:shorewall][:interfaces] = %w{ eth0 }
