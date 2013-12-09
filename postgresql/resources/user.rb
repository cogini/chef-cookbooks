actions :create
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :password, :kind_of => String, :default => nil
attribute :connection_limit, :kind_of => Integer, :default => nil
