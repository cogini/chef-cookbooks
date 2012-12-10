default[:tarsnap][:version] = '1.0.33'

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
