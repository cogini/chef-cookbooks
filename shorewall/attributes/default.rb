default[:shorewall][:allowed_ports] = [
    22,
    80,
    443,
]
default[:shorewall][:blocked_ports] = []
default[:shorewall][:allowed_hosts] = []

# Allow connections from A:any to server:B
# [
#   ["IP1 IP2 ...", "PortA PortB"],
#   ...
# ]
default[:shorewall][:allowed_connections] = []
