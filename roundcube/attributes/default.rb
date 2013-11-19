::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default[:roundcube][:default_port] = 143
default[:roundcube][:imap_force_caps] = false
default[:roundcube][:des_key] = secure_password[0..23]
