#
# Cookbook Name:: elixir
# Recipe:: _package
#
# Copyright (C) 2013-2014 Jamie Winsor (<jamie@vialstudios.com>)
#


case node['platform_family']
  when 'debian'
    node.normal[:apt][:compile_time_update] = true
    node.normal[:erlang][:esl][:version] = "1:17.5"
    package 'unzip'
  when 'rhel'
    node.normal[:erlang][:esl][:version] = "17.5-1.el6"
end

elixir_version = node[:elixir][:version]
elixir_zip_file = "#{Chef::Config['file_cache_path']}/elixir-#{elixir_version}.zip"
elixir_path = File.join(node[:elixir][:_versions_path], elixir_version)

include_recipe "erlang::esl"


remote_file elixir_zip_file do
    action :create_if_missing
    source "https://github.com/elixir-lang/elixir/releases/download/#{elixir_version}/Precompiled.zip"
end

directory elixir_path do
  recursive true
end

execute "Extract elixir-#{elixir_version}.zip" do
    command "unzip -n #{elixir_zip_file} -d #{elixir_path}"
end

link node[:elixir][:install_path] do
    to elixir_path
end
