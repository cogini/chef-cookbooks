if platform_family?('debian', 'rhel')
  default['sysctl']['conf_dir'] = '/etc/sysctl.d'
else
  default['sysctl']['conf_dir'] = nil
end
default['sysctl']['allow_sysctl_conf'] = false

# Default is 32MB which is too low to be useful
default['sysctl']['params']['kernel']['shmmax'] = 67108864 # 64MB
