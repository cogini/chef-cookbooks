default[:shorewall][:allowed_ports] = [
    22,
    80,
    443,
]
default[:shorewall][:blocked_ports] = []
default[:shorewall][:allowed_hosts] = []

# default[:shorewall][:allowed_connections] = [
#                                               ["192.168.1.1,192.168.1.2","1000,1001,1002"],
#                                               ["192.168.1.3","1004"]
#                                             ]
default[:shorewall][:allowed_connections] = []
