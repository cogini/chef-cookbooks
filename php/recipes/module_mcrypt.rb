#
# Author::  Hoang Xuan Phu (<phu@cogini.com>)
# Cookbook Name:: php
# Recipe:: module_mcrypt
#

case node['platform']
when "ubuntu"
    package "php5-mcrypt" do
        action :install
    end
else
    raise NotImplementedError
end
