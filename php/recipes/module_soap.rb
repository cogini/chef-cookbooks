#
# Author::  Hoang Xuan Phu (<phu@cogini.com>)
# Cookbook Name:: php
# Recipe:: module_soap
#

case node['platform']
when 'amazon', 'centos'
    package 'php-soap' do
        action :install
    end
when 'ubuntu'
    package 'php-soap' do
        action :install
    end
else
    raise NotImplementedError
end
