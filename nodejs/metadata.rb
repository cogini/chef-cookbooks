maintainer       "Promet Solutions"
maintainer_email "marius@promethost.com"
license          "Apache 2.0"
description      "Installs/Configures nodejs"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.6.11"
recipe           "nodejs", "Installs Node.JS from source"

depends          "build-essential"
