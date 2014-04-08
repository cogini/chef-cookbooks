# Cookbook Name:: nsca-client
# Recipe:: default
#
# Copyright 2014, Cogini
#
# All rights reserved - Do Not Redistribute

# CentOS needs EPEL repo to install nsca-client package
if node["platform"] == "centos"
    yum_repository 'epel' do
        description 'Extra Packages for Enterprise Linux'
        mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
        gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
        action :create
    end
end

if ["centos", "fedora", "ubuntu", "debian"].include?(node["platform"])
    package "nsca-client" do
        action :install
    end
else
    raise NotImplementedError
end
