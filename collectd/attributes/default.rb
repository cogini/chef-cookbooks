default[:collectd][:fqdn_lookup] = true
default[:collectd][:version] = '5.4.1'
default[:collectd][:plugins] = {}
default[:collectd][:types] = {}

case node[:platform_family]
when 'rhel'
    default[:collectd][:packages] = %w{
        libcollectdclient
        collectd
        collectd-perl
        collectd-collection3
        collectd-rrdtool
    }
else
    raise NotImplemented
end
