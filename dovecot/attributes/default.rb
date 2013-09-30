# mysql, pgsql or sqlite
default[:dovecot][:db][:driver] = 'sqlite'

# Used by mysql and pgsql
default[:dovecot][:db][:host] = 'localhost'

set[:dovecot][:packages] = %w{
    dovecot-imapd
    dovecot-pop3d
}
