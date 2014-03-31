Description
===========
Installs/Configures Amazon SES via SMTP, with DKIM

Requirements
============
## Platform:
* Ubuntu (tested on 10.04)
## Software:
* Postfix

Attributes
==========


## Usage

Do not use the cookbook directly, toggle `enable_dkim` in the `postfix`
cookbook instead.

```javascript
"dkim": {
    "domains": [
        "your-domain.com"
    ]
},
"postfix": {
    "enable_dkim": true
},
"run_list": [
    "recipe[postfix]"
]
```

Provision, then add a DNS record as indicated in `/etc/mail/mail.txt`.
