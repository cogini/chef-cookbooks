case node[:platform_family]
when 'rhel'
    package 'php-pear-Log' do
        # TODO HXP: maybe FPM is not used
        notifies :restart, "service[#{node[:php][:fpm_service]}]"
    end
else
    raise NotImplementedError
end
