case platform
when "redhat", "centos"
    set[:fpm][:dependencies] = %w{
        rubygems
        ruby-devel
        rpm-build
    }
    set[:fpm][:provider] = Chef::Provider::Package::Rpm
else
    # Ubuntu
    set[:fpm][:dependencies] = %w{
        rubygems
        ruby-dev
    }
    set[:fpm][:provider] = Chef::Provider::Package::Dpkg
end
