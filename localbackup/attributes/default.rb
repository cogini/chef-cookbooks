default[:localbackup][:destination] = '/usr/local/backups'
default[:localbackup][:dirs] = %w{
    /etc
}
default[:localbackup][:time] = 0

default[:localbackup][:mysql][:enable] = File.exists?('/usr/bin/mysqldump')
if (node[:localbackup][:mysql][:enable])
    default[:localbackup][:mysql][:user] = 'root'
    default[:localbackup][:mysql][:password] = node[:mysql][:server_root_password]
end

default[:localbackup][:pgsql][:enable] = File.exists?('/usr/bin/pg_dump')
