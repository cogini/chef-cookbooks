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

bash 'install-yii' do
    code <<-EOH
        [[ -d #{yii_path} ]] || git clone https://github.com/yiisoft/yii.git #{yii_path}
        cd #{yii_path}
        git fetch
        git checkout #{node[:yii][:version]}
    EOH
end

execute "ln -snf #{node[:yii][:path]} #{node[:yii][:symlink]}" do
    only_if {node[:yii][:symlink]}
end
