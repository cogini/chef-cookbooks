case node[:platform_family]
when 'rhel'
    # TODO: maybe use the RPM package instead:
    # package 'php-pear-Log'
    php_pear 'log'
else
    raise NotImplementedError
end
