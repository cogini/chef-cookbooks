case node[:platform]
when 'centos', 'redhat', 'fedora', 'amazon'
    set[:munin][:packages] = %w{ munin-node }
    set[:munin][:log_dir] = '/var/log/munin-node'
when 'debian', 'ubuntu'
    set[:munin][:log_dir] = '/var/log/munin'
    if node[:platform_version].to_f >= 10.04
        set[:munin][:packages] = %w{ munin-node munin-plugins-extra }
    else
        set[:munin][:packages] = %w{ munin-node }
    end
end

