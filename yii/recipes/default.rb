#
# DEPRECATED, USE yii_framework INSTEAD
#
# Cookbook Name:: yii
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'git'

yii_path = node[:yii][:path]

directory File.dirname(yii_path) do
    action :create
    recursive true
end

git "Clone yii #{node[:yii][:version]}" do
    repository "https://github.com/yiisoft/yii.git"
    reference node[:yii][:version]
    destination yii_path
end

execute "ln -snf #{node[:yii][:path]} #{node[:yii][:symlink]}" do
    only_if {node[:yii][:symlink]}
end
