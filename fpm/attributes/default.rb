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
    set[:fpm][:provider] = Chef::Provider::Package::Dpkg
    if node[:platform_version].to_f >= 10.04
        set[:fpm][:dependencies] = %w{
            rubygems
            ruby-dev
        }
    else
        set[:fpm][:dependencies] = %w{
        }
    end
end
