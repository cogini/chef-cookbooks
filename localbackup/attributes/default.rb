script_dir = '/root/localbackup'
set[:localbackup][:script_dir] = script_dir
set[:localbackup][:ignore_file] = "#{script_dir}/ignore"
set[:localbackup][:script_file] = "#{script_dir}/make_backup.sh"

default[:localbackup][:destination] = '/usr/local/backups'
default[:localbackup][:ignore] = []

default[:localbackup][:mysql][:enable] = File.exists?('/etc/init.d/mysql')
default[:localbackup][:pgsql][:enable] = File.exists?('/etc/init.d/postgresql')

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
