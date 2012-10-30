default[:nagios][:pgsql][:enable] = false
default[:nagios][:pgsql][:host] = 'localhost'
default[:nagios][:pgsql][:username] = 'nagiosCheck'

default[:nagios][:mysql][:enable] = false
default[:nagios][:mysql][:host] = 'localhost'
default[:nagios][:mysql][:username] = 'nagiosCheck'

default[:nagios][:total_procs][:warning] = 150
default[:nagios][:total_procs][:critical] = 200
