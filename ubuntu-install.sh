#!/bin/bash

# Taken from https://github.com/jedi4ever/veewee/blob/master/templates/ubuntu-12.04.2-server-i386/postinstall.sh

# Install Ruby from source in /opt so that users of Vagrant
# can install their own Rubies using packages or however.
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz
tar xvzf ruby-1.9.2-p290.tar.gz
cd ruby-1.9.2-p290
./configure --prefix=/opt/ruby
make
make install
cd ..
rm -rf ruby-1.9.2-p290

# Install RubyGems 1.7.2
wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.11.tgz
tar xzf rubygems-1.8.11.tgz
cd rubygems-1.8.11
/opt/ruby/bin/ruby setup.rb
cd ..
rm -rf rubygems-1.8.11

# Installing chef & Puppet
/opt/ruby/bin/gem install chef --no-ri --no-rdoc
#/opt/ruby/bin/gem install puppet --no-ri --no-rdoc

# Add /opt/ruby/bin to the global path as the last resort so
# Ruby, RubyGems, and Chef/Puppet are visible
echo 'PATH=$PATH:/opt/ruby/bin/'> /etc/profile.d/vagrantruby.sh
