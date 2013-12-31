#
# Cookbook Name:: yum
# Recipe:: postgresql91
#
# Copyright 2012, Cogini
#


unless node[:yum][:main][:exclude] and node[:yum][:main][:exclude].include?('postgresql*')
    raise 'node[:yum][:main][:exclude] must include "postgresql*"'
end


key = "#{node.platform}#{node.platform_version.to_i}"

case key
when 'centos6'
    package_from_url 'http://yum.postgresql.org/9.1/redhat/rhel-6-x86_64/pgdg-centos91-9.1-4.noarch.rpm'
else
    raise NotImplementedError
end

yum_repository 'pgdg-91-centos' do
    description 'PostgreSQL 9.1 $releasever - $basearch'
    baseurl 'http://yum.postgresql.org/9.1/redhat/rhel-$releasever-$basearch'
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG'
    includepkgs 'postgresql*'
end
