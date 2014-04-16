#
# Cookbook Name:: yum
# Recipe:: remi
#
# Copyright 2012, Cogini
#

yum_repository 'remi' do
    description 'Les RPM de remi pour Enterprise Linux $releasever - $basearch'
    mirrorlist 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror'
    gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
end
