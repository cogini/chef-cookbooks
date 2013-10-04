define :package_from_file do

  package_file = params[:name]
  base_name = package_file.split('/')[-1]

  if node[:platform] == 'ubuntu'
    include_recipe 'gdebi'
  end

  package base_name do
    source package_file
    provider node[:basics][:local_package_provider]
  end

end
