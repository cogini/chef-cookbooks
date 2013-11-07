Description
===========

Installs and configures postfix for client or outbound relayhost, or
to do SASL authentication.

On RHEL-family systems, sendmail will be replaced with postfix.

Requirements
============

## Platform:

* Ubuntu 10.04+
* Debian 6.0+
* RHEL/CentOS/Scientific 5.7+, 6.2+
* Amazon Linux (as of AMIs created after 4/9/2012)

Attributes
==========

See `attributes/default.rb` for default values.

* `node['postfix']['myhostname']` - corresponds to the myhostname
  option in `/etc/postfix/main.cf`.
* `node['postfix']['mydomain']` - corresponds to the mydomain option
  in `/etc/postfix/main.cf`.
* `node['postfix']['myorigin']` - corresponds to the myorigin option
  in `/etc/postfix/main.cf`.
* `node['postfix']['relayhost']` - corresponds to the relayhost option
  in `/etc/postfix/main.cf`.
* `node['postfix']['relayhost_role']` - name of a role used for search
  in the client recipe.
* `node['postfix']['multi_environment_relay']` - set to true if nodes
  should not constrain search for the relayhost in their own
  environment.
* `node['postfix']['mail_relay_networks']` - corresponds to the
  mynetworks option in `/etc/postfix/main.cf`.
* `node['postfix']['smtpd_use_tls']` - set to "yes" to use TLS for
  SMTPD, which will use the snakeoil certs.
* `node['postfix']['smtp_sasl_auth_enable']` - set to "yes" to enable
  SASL authentication for SMTP.
* `node['postfix']['smtp_sasl_password_maps']` - corresponds to the
  `smtp_sasl_password_maps` option in `/etc/postfix/main.cf`.
* `node['postfix']['smtp_sasl_security_options']` - corresponds to the
  `smtp_sasl_security_options` option in `/etc/postfix/main.cf`.
* `node['postfix']['smtp_tls_cafile']` - corresponds to the
  `smtp_tls_CAfile` option in `/etc/postfix/main.cf`.
* `node['postfix']['aliases']` - hash of aliases to create with
  `recipe[postfix::aliases]`, see below under __Recipes__ for more
  information.

Recipes
=======

default
-------

Installs the postfix package and manages the service and the main
configuration files (`/etc/postfix/main.cf` and
`/etc/postfix/master.cf`). See __Usage__ and __Examples__ to see how
to affect behavior of this recipe through configuration.

For a more dynamic approach to discovery for the relayhost, see the
`client` and `server` recipes below.

client
------

Use this recipe to have nodes automatically search for the mail relay
based which node has the `node['postfix']['relayhost']` role. Sets the
`node['postfix']['relayhost']` attribute to the first result from the
search.

Includes the default recipe to install, configure and start postfix.

Does not work with `chef-solo`.


dovecot\_SQL
---------------

The SQL database should have this schema:

    CREATE TABLE aliases (source varchar(128), destination varchar(1024));
    CREATE TABLE transports (domain varchar(128));
    CREATE TABLE users (user varchar(128), password varchar(128), uid integer, gid integer, mail_dir varchar(128));


sasl\_auth
----------

Sets up the system to authenticate with a remote mail relay using SASL
authentication.

Usage
=====

On systems that should simply send mail directly to a relay, or out to
the internet, use `recipe[postfix]` and modify the
`node['postfix']['relayhost']` attribute via a role.

If you need to use SASL authentication to send mail through your ISP
(such as on a home network), use `recipe[postfix::sasl_auth]` and set
the appropriate attributes.

For each of these implementations, see __Examples__ for role usage.

Examples
--------

The example roles below only have the relevant postfix usage. You may
have other contents depending on what you're configuring on your
systems.

For an example of using encrypted data bags to encrypt the SASL
password, see the following blog post:

* http://jtimberman.github.com/blog/2011/08/06/encrypted-data-bag-for-postfix-sasl-authentication/


### Sending through Mandrill

```javascript
"postfix": {
    "relayhost": "[smtp.mandrillapp.com]",
    "smtp_sasl_auth_enable": "yes",
    "smtp_sasl_password_maps": "hash:/etc/postfix/smtp_sasl_passwords",
    "smtp_sasl_passwords": [
        {
            "password": "A_SECRET",
            "remote": "[smtp.mandrillapp.com]",
            "username": "ANOTHER_SECRET"
        }
    ],
    "smtp_use_tls": "yes"
},
"run_list": [
    "recipe[postfix]",
    "recipe[postfix::sasl_auth]"
],
```


**Examples using the client & server recipes**

If you'd like to use the more dynamic search based approach for discovery, use the server and client recipes. First, create a relayhost role.

    name "relayhost"
    run_list("recipe[postfix::server]")
    override_attributes(
      "postfix" => {
        "mail_relay_networks" => "10.3.3.0/24",
        "mydomain" => "example.com",
        "myorigin" => "example.com"
      }
    )

If you wish to use a different role name for the relayhost, then also set the attribute in the `base` role. For example, `postfix_master` as the role name:

    name "postfix_master"
    description "a role for postfix master that isn't relayhost"
    run_list("recipe[postfix::server]")
    override_attributes(
      "postfix" => {
        "mail_relay_networks" => "10.3.3.0/24",
        "mydomain" => "example.com",
        "myorigin" => "example.com"
      }
    )

License and Author
==================

Author:: Joshua Timberman <joshua@opscode.com>

Copyright:: 2009-2012, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
