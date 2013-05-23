# Description

[![Build Status](https://secure.travis-ci.org/realityforge/chef-postgis.png?branch=master)](http://travis-ci.org/realityforge/chef-postgis)

The postgis cookbook installs and configures the Postgis Postgresql extension and creates a GIS enabled database template.

# Requirements

## Platform:

* Ubuntu

## Cookbooks:

* apt
* postgresql

# Attributes

* `node['postgis']['template_name']` - The name of the gis database template. Set to nil to disable the creation of the template.. Defaults to `template_postgis`.

# Recipes

* postgis::default - Install the Postgis binaries and create the template. Note: this includes the postgresql::server after installing the postgis binaries.

### Locale

It should be noted that it is best setup the locale so that
the encoding is the desired database encoding prior to including
the recipe. Typically this is set via a snippet such as;

    node.override['locale']['lang'] = 'en_AU.UTF-8'
    include_recipe 'locale::default'

    include_recipe 'postgis::default'

# License and Maintainer

Maintainer:: Peter Donald (<peter@realityforge.org>)

License:: Apache 2.0
