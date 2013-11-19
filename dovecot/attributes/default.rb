# mysql, pgsql or sqlite
default[:dovecot][:db][:driver] = 'sqlite'

# Used by mysql and pgsql
default[:dovecot][:db][:host] = 'localhost'

default[:dovecot][:db][:columns][:user] = 'user'
default[:dovecot][:db][:columns][:password] = 'password'
default[:dovecot][:db][:columns][:gid] = 'gid'
default[:dovecot][:db][:columns][:uid] = 'uid'
default[:dovecot][:db][:columns][:home_dir] = 'home_dir'
default[:dovecot][:db][:columns][:mail_dir] = 'mail_dir'

default[:dovecot][:disable_plaintext_auth] = 'no'
default[:dovecot][:enable_sieve] = false

set[:dovecot][:packages] = %w{
    dovecot-imapd
    dovecot-pop3d
}
