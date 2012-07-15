default[:localbackup][:destination] = '/usr/local/backups'
default[:localbackup][:dirs] = %w{
    /etc
}
default[:localbackup][:time] = 17
default[:localbackup][:mysql][:enable] = false
default[:localbackup][:pgsql][:enable] = File.exists?('/usr/bin/pg_dump')
