#
# Author::  Hoang Xuan Phu (<phu@cogini.com>)
# Cookbook Name:: php
# Recipe:: module_dom
#

case node['platform']
when 'amazon', 'centos'
    package 'php-dom' do
        action :install
    end
when 'ubuntu'
    # DOM included by default, no action needed
else
    raise NotImplementedError
end
