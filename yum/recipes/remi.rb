#
# Cookbook Name:: yum
# Recipe:: remi
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

yum_key 'RPM-GPG-KEY-remi' do
    url 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
    action :add
end

yum_repository 'remi' do
    description 'Les RPM de remi pour Enterprise Linux $releasever - $basearch'
    url 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror'
    key 'RPM-GPG-KEY-remi'
    mirrorlist true
    action :add
end
