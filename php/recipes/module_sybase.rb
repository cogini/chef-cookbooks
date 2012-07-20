#
# Author::  Hoang Xuan Phu (<phu@cogini.com>)
# Cookbook Name:: php
# Recipe:: module_sybase
#

case node['platform']
when 'ubuntu'
    package 'php5-sybase' do
        action :install
    end
else
    raise NotImplementedError
end
