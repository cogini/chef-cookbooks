name             'postgis'
maintainer       'Peter Donald'
maintainer_email 'peter@realityforge.org'
license          'Apache 2.0'
description      'Installs/Configures postgis Postgresql extension'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.3'

depends 'apt'
depends 'postgresql'

supports 'ubuntu'

recipe 'postgis::default', 'Install the Postgis binaries and create the template. Note: this includes the postgresql::server after installing the postgis binaries.'

attribute 'postgis/template_name',
  :display_name => 'Postgis Template Database',
  :description => 'The name of the gis database template. Set to nil to disable the creation of the template.',
  :type => 'string',
  :default => 'template_postgis'
