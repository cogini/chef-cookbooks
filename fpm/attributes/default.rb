case platform
when 'redhat', 'centos'
    set[:fpm][:provider] = Chef::Provider::Package::Rpm
    set[:fpm][:dependencies] = %w{
        rubygems
        ruby-devel
        rpm-build
    }
    set[:fpm][:package_type] = 'rpm'
when 'ubuntu'
    set[:fpm][:provider] = Chef::Provider::Package::Dpkg
    set[:fpm][:dependencies] = %w{
        rubygems
        ruby-dev
    }
    set[:fpm][:package_type] = 'deb'
end
