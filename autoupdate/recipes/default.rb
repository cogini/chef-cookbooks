case node[:platform_family]
when 'rhel'
    include_recipe 'autoupdate::redhat'
when 'debian'
    include_recipe 'autoupdate::ubuntu'
end
