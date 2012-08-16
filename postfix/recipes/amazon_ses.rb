#
# Cookbook Name:: postfix
# Recipe:: amazon_ses
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'dkim'
include_recipe 'postfix::dkim'

ses_username = node[:ses][:username]
ses_password = node[:ses][:password]

bash 'config_ses' do
    code <<-EOBASH
        cp /etc/postfix/main.cf{,.chef-mail-amazon_ses-backup}
        cat >> /etc/postfix/main.cf <<EOSES

# Amazon SES
relayhost = email-smtp.us-east-1.amazonaws.com:25
smtp_sasl_auth_enable = yes
smtp_sasl_security_options = noanonymous
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_use_tls = yes
smtp_tls_security_level = encrypt
smtp_tls_note_starttls_offer = yes
# End Amazon SES
EOSES

        echo 'email-smtp.us-east-1.amazonaws.com:25 #{ses_username}:#{ses_password}' > /etc/postfix/sasl_passwd
        postmap hash:/etc/postfix/sasl_passwd
        rm /etc/postfix/sasl_passwd
        postconf -e 'smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt'
    EOBASH
    not_if "grep 'Amazon SES' /etc/postfix/main.cf"
end
