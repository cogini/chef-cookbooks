actions :create
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :options, :kind_of => Array, :default => []
