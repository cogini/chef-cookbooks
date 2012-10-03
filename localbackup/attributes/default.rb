default[:localbackup][:destination] = '/usr/local/backups'

case node[:platform]
when 'ubuntu'
    default[:localbackup][:dirs] = %w{
        /etc
        /var/backups
    }
else
    default[:localbackup][:dirs] = %w{
        /etc
    }
end

default[:localbackup][:mysql][:enable] = File.exists?('/usr/bin/mysqldump')
if node[:localbackup][:mysql][:enable]
    default[:localbackup][:mysql][:user] = 'root'
    if node[:mysql] && node[:mysql][:server_root_password]
        default[:localbackup][:mysql][:password] = node[:mysql][:server_root_password]
    end
end

default[:localbackup][:pgsql][:enable] = File.exists?('/usr/bin/pg_dump')
