#
# Cookbook Name:: postfix
# Recipe:: dkim
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

bash "postfix_dkim" do
    code <<-EOBASH
        cp /etc/postfix/main.cf{,.chef-mail-postfix_dkim-backup}
        cat >> /etc/postfix/main.cf <<EODKIM

# DKIM
milter_default_action = accept
milter_protocol = 2
smtpd_milters = inet:localhost:8891
non_smtpd_milters = inet:localhost:8891
# End DKIM
EODKIM

    EOBASH
    not_if "grep 'DKIM' /etc/postfix/main.cf"
end
