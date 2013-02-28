default[:shorewall][:allowed_ports] = [
    22,
    80,
    443,
]
default[:shorewall][:blocked_ports] = []
default[:shorewall][:allowed_hosts] = []

# Allow connections from A:any to server:B
# [
#   ["source ip", "dest port"],
#   ...
# ]
default[:shorewall][:allowed_connections] = []
