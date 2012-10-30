case node[:platform]
when 'centos', 'redhat', 'fedora', 'amazon'
    default[:munin][:packages] = %w{ munin-node }
when 'debian', 'ubuntu'
    default[:munin][:packages] = %w{ munin-node munin-plugins-extra}
end

