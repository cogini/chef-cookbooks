define :package_from_url do

  url = params[:name]
  base_name = url.split('/')[-1]
  package_file = "#{Chef::Config[:file_cache_path]}/#{base_name}"

  if node[:platform] == 'ubuntu'
    include_recipe 'apt'
    include_recipe 'gdebi'
  end

  remote_file package_file do
    source url
    action :create_if_missing
  end

  package base_name do
    source package_file
    provider node[:basics][:local_package_provider]
  end

end
