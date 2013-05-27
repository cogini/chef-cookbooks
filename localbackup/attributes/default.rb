script_dir = '/root/localbackup'
set[:localbackup][:script_dir] = script_dir
set[:localbackup][:ignore_file] = "#{script_dir}/ignore"
set[:localbackup][:script_file] = "#{script_dir}/make_backup.sh"

default[:localbackup][:destination] = '/usr/local/backups'
default[:localbackup][:dirs] = %w{ /etc }
default[:localbackup][:ignore] = []

default[:localbackup][:mysql][:enable] = File.exists?('/etc/init.d/mysql')
default[:localbackup][:pgsql][:enable] = (not Dir.glob('/etc/init.d/postgresql*').empty?)

# MySQL 5.1 an up needs `--events`
# MySQL 5.0 and down doesn't have it
default[:localbackup][:mysql][:extra_options] = '--events'

case node[:platform]
when 'ubuntu'
    default[:localbackup][:dirs] = %w{
        /etc
        /var/backups
    }
    if node[:platform_version].to_f < 10.04
        default[:localbackup][:mysql][:extra_options] = ''
    end
end
