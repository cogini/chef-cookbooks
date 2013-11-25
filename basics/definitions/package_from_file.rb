define :package_from_file do

  package_file = params[:name]
  type = package_file.split('.')[-1]

  case type
  when 'deb'
    # The default provider (APT) doesn't like local files.
    include_recipe 'gdebi'
    provider = Chef::Provider::Package::Gdebi
  when 'rpm'
    provider = Chef::Provider::Package::Yum
  end

  package package_file do
    source package_file
    provider provider
  end

end
