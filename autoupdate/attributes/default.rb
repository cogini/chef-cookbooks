case node[:platform]
when 'ubuntu'
    # Origins: security, updates, proposed, backports
    default[:autoupdate][:origins] = [
        "security",
        "updates"
    ]
    default[:autoupdate][:auto_fix_interrupted_dpkg] = true
    default[:autoupdate][:email] = "noc@cogini.com"
    deafult[:autoupdate][:remove_unused_dependencies] = true
    deafult[:autoupdate][:update_package_lists_interval] = 1
    default[:autoupdate][:clean_downloaded_packages_interval] = 15
    default[:autoupdate][:upgrade_interval] = 1

when 'centos', 'redhat'
else
    raise NotImplementedError
end
