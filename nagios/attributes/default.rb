default[:nagios][:mysql][:enable] = false
default[:nagios][:mysql][:host] = 'localhost'
default[:nagios][:mysql][:username] = 'nagiosCheck'
default[:nagios][:pgsql][:enable] = false
default[:nagios][:pgsql][:host] = 'localhost'
default[:nagios][:pgsql][:username] = 'nagiosCheck'
default[:nagios][:plugin_dir] = '/usr/lib/nagios/plugins/local'
default[:nagios][:total_procs][:critical] = 200
default[:nagios][:total_procs][:warning] = 150

case node[:platform]
when 'redhat', 'centos'
    default[:nagios][:pid_file] = '/var/run/nrpe/nrpe.pid'
    default[:nagios][:recipe] = 'nagios::redhat'
    default[:nagios][:service] = 'nrpe'
when 'ubuntu'
    default[:nagios][:recipe] = 'nagios::ubuntu'
    default[:nagios][:service] = 'nagios-nrpe-server'
    if node['platform_version'].to_f >= 10.04
        default[:nagios][:pid_file] = '/var/run/nagios/nrpe.pid'
    else
        default[:nagios][:pid_file] = '/var/run/nrpe.pid'
    end
end
