define :package_from_file do

  package_file = params[:name]
  type = package_file.split('.')[-1]

  case type
  when 'deb'
    # The default provider (APT) doesn't like local files.
    include_recipe 'gdebi'
    provider = Chef::Provider::Package::Gdebi
  when 'rpm'
    # The default provider (YUM) wants a version to
    # be specified, which is inconvenient.
    provider = Chef::Provider::Package::Rpm
  end

  package package_file do
    source package_file
    provider provider
  end

end
