#
# Cookbook Name:: yum
# Recipe:: epel
#
# Copyright 2012, Cogini
#

yum_repository 'epel' do
    description 'Extra Packages for Enterprise Linux 6 - $basearch'
    mirrorlist 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch'
    gpgkey 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
end
