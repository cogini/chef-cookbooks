script_dir = '/root/localbackup'
set[:localbackup][:script_dir] = script_dir
set[:localbackup][:ignore_file] = "#{script_dir}/ignore"
set[:localbackup][:script_file] = "#{script_dir}/make_backup.sh"

default[:localbackup][:destination] = '/usr/local/backups'
default[:localbackup][:dirs] = %w{ /etc }
default[:localbackup][:enable] = true
default[:localbackup][:ignore] = []
default[:localbackup][:tar_options] = '--warning=no-file-changed --warning=no-file-removed'

default[:localbackup][:mysql][:enable] = File.exists?('/etc/init.d/mysql')
default[:localbackup][:pgsql][:enable] = (not Dir.glob('/etc/init.d/postgresql*').empty?)

case node[:platform]
when 'ubuntu'
    if node[:platform_version].to_f < 12.04
        default[:localbackup][:tar_options] = ''
    end
when 'redhat'
    if node[:platform_version].to_f < 6
        default[:localbackup][:tar_options] = ''
    end
end
