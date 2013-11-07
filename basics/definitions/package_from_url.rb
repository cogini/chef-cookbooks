define :package_from_url do

  url = params[:name]
  base_name = url.split('/')[-1]
  package_file = "#{Chef::Config[:file_cache_path]}/#{base_name}"

  remote_file package_file do
    source url
    action :create_if_missing
  end

  package_from_file package_file

end
