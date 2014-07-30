set[:amanda][:app_group] = 'disk'
set[:amanda][:app_user] = 'amandabackup'

default[:amanda][:cron_time] = 0
default[:amanda][:home] = '/var/lib/amanda'
default[:amanda][:inparallel] = 10
default[:amanda][:netusage] = '80 MBps'
default[:amanda][:runtapes] = 1
default[:amanda][:number_of_tapes] = node[:amanda][:runtapes] * 15
default[:amanda][:version] = '3.3.4'

# 'backup_locations': [
#   {
#     'hostname' : 'localhost',
#     'port'     : '1234',
#     'locations': [
#       '/etc',
#       '/var/www'
#     ]
#   }
# ]
default[:amanda][:backup_locations] = []


a_version = node[:amanda][:version]
p_version = node[:platform_version]

case node[:platform_family]
when 'debian'
  arch = node[:kernel][:machine] =~ /x86_64/ ? 'amd64' : 'i386'
  dotless = p_version.to_s.delete '.'
  set[:amanda][:package_url] = "http://www.zmanda.com/downloads/community/Amanda/#{a_version}/Ubuntu-#{p_version}/amanda-backup-client_#{a_version}-1Ubuntu#{dotless}_#{arch}.deb"
when 'rhel'
  arch = node[:kernel][:machine] =~ /x86_64/ ? 'x86_64' : 'i686'
  set[:amanda][:package_url] = "http://www.zmanda.com/downloads/community/Amanda/#{a_version}/Redhat_Enterprise_#{p_version.to_i}.0/amanda-backup_client-#{a_version}-1.rhel#{p_version.to_i}.#{arch}.rpm"
else
  raise NotImplementedError
end
