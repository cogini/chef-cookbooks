#
# Cookbook Name:: yii
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

require_recipe "git"

bash "install-yii" do
    cwd "/opt"
    code <<-EOH
        git clone https://github.com/yiisoft/yii.git
        cd yii
        git fetch
        git checkout #{node[:yii][:version]}
    EOH
end

execute "ln -s /opt/yii #{node[:yii][:symlink]}" do
    only_if {node[:yii][:symlink]}
end
