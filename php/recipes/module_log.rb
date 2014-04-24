case node[:platform_family]
when 'rhel'
    package 'php-pear-Log' do
        # TODO HXP: maybe FPM is not used
        notifies :restart, 'service[php-fpm]'
    end
else
    raise NotImplementedError
end
