#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2013, Cogini
#

version = node[:nodejs][:version]
arch = node[:kernel][:machine] =~ /x86_64/ ? '64bit' : '32bit'
package_from_url "http://packages.cogini.com/nodejs-#{version}-#{arch}.deb"
