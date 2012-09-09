#
# Author::  Hoang Xuan Phu (<phu@cogini.com>)
# Cookbook Name:: php
# Recipe:: module_mbstring
#

case node['platform']
when 'amazon', 'centos'
    package 'php-mbstring' do
        action :install
    end
when 'ubuntu'
    # mbstring included by default, no action needed
else
    raise NotImplementedError
end
