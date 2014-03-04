actions :create
default_action :create

attribute :version, :kind_of => String, default: '1.1.10', :name_attribute => true
attribute :symlink, :kind_of => String, default: nil
attribute :path, :kind_of => String, default: nil
