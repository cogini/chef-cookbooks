name              "postfix"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures postfix for client or outbound relayhost, or to do SASL auth"
version           "1.2.0"
recipe            "postfix", "Installs and configures postfix"
recipe            "postfix::sasl_auth", "Set up postfix to auth to a server with sasl"
recipe            "postfix::aliases", "Manages /etc/aliases"
recipe            "postfix::client", "Searches for the relayhost based on an attribute"
depends           "dkim"

%w{ubuntu debian redhat centos amazon scientific}.each do |os|
  supports os
end

attribute "postfix",
  :display_name => "Postfix",
  :description => "Hash of Postfix attributes",
  :type => "hash"

attribute "postfix/aliases",
  :display_name => "Postfix Aliases",
  :description => "Hash of Postfix aliases mapping a name to a value.  Example 'root' => 'operator@example.com'.  See aliases man page for details.",
  :type => "hash"

attribute "postfix/myhostname",
  :display_name => "Postfix Myhostname",
  :description => "Sets the myhostname value in main.cf",
  :default => "fqdn"

attribute "postfix/mydomain",
  :display_name => "Postfix Mydomain",
  :description => "Sets the mydomain value in main.cf",
  :default => "domain"

attribute "postfix/myorigin",
  :display_name => "Postfix Myorigin",
  :description => "Sets the myorigin value in main.cf",
  :default => "$myhostname"

attribute "postfix/relayhost",
  :display_name => "Postfix Relayhost",
  :description => "Sets the relayhost value in main.cf",
  :default => ""

attribute "postfix/mail_relay_networks",
  :display_name => "Postfix Mail Relay Networks",
  :description => "Sets the mynetworks value in main.cf",
  :default => "127.0.0.0/8"

attribute "postfix/smtp_sasl_auth_enable",
  :display_name => "Postfix SMTP SASL Auth Enable",
  :description => "Enable SMTP SASL Authentication",
  :default => "no"

attribute "postfix/smtp_sasl_password_maps",
  :display_name => "Postfix SMTP SASL Password Maps",
  :description => "hashmap of SASL passwords",
  :default => "hash:/etc/postfix/sasl_passwd"

attribute "postfix/smtp_sasl_security_options",
  :display_name => "Postfix SMTP SASL Security Options",
  :description => "Sets the value of smtp_sasl_security_options in main.cf",
  :default => "noanonymous"

attribute "postfix/smtp_tls_cafile",
  :display_name => "Postfix SMTP TLS CA File",
  :description => "CA certificate file for SMTP over TLS",
  :default => "/etc/postfix/cacert.pem"

attribute "postfix/aliases",
  :display_name => "Postfix mail aliases",
  :description => "Hash of mail aliases for /etc/aliases",
  :default => ""

attribute "postfix/relayhost_role",
  :display_name => "Postfix Relayhost's role",
  :description => "String containing the role name",
  :default => "relayhost"

attribute "postfix/multi_environment_relay",
  :display_name => "Postfix Search for relayhost in any environment",
  :description => "If true, then the client recipe will search any environment instead of just the node's",
  :default => ""
