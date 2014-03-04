#
# Cookbook Name:: basics
# Recipe:: packages
#
# Copyright 2012, Cogini
#

node[:basics][:packages].each do |pkg|
    package pkg do
        unless node[:basics][:package_mask].include?(pkg)
            action :install
        else
            action :remove
        end
    end
end

node[:basics][:package_mask].each do |pkg|
    package pkg do
        unless node[:basics][:package_unmask].include?(pkg)
            action :remove
        else
            action :install
        end
    end
end

package 'unattended-upgrades' do
    unless node[:basics][:enable_unattended_upgrades]
        action :remove
    else
        action :install
    end
end
