default[:tarsnap][:version] = '1.0.33'
default[:tarsnap][:script_dir] = '/root/tarsnap'
default[:tarsnap][:ignore_file] = '/root/tarsnap/ignore'
default[:tarsnap][:ignore] = []

case node[:platform]
when 'ubuntu'
    default[:tarsnap][:dirs] = %w{
        /etc
        /var/backups
    }
else
    default[:tarsnap][:dirs] = %w{
        /etc
    }
end
