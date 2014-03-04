case node[:platform]
when 'redhat', 'centos'
    include_recipe 'autoupdate::redhat'
when 'ubuntu'
    include_recipe 'autoupdate::ubuntu'
else
    raise NotImplementedError
end
