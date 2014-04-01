#
# Cookbook Name:: yum
# Recipe:: postgresql91
#
# Copyright 2012, Cogini
#

# XXX HXP: Maybe using `yum_repository` is a better idea
package_from_url node[:yum][:postgresql_repo_url]
