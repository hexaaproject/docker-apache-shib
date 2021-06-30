# apache2-shib

Docker image for Apache2.4 + Shibboleth3 (SP). Allows hosting web
applications with SAML SSO authentication.

Forked from [solazs/docker-apache-shib](https://github.com/solazs/docker-apache-shib)

The built image is available on [Docker Hub](https://hub.docker.com/r/hexaaproject/apache-shib)

## Building

`docker build -t hexaaproject/apache-shib .`

## Usage

You can see an example config in the [HEXAA frontend Ansible role](https://github.com/hexaaproject/ansible-role-hexaa-frontend)

Mount your Apache config to `/etc/sites-enabled/000-default.conf` (more
config files can be mounted under `/etc/sites-enabled/`).

Mount any Shibboleth config files under `/etc/shibboleth/` to override
the default config. Don't forget to mount your own certs and keys
(`/opt/certs-shib`) for Shibboleth to use or enable generating at
startup.


**Available environment variables:**

* `APACHE_SHIB_APACHE_MODULES_TO_START`: default value: `"shib ssl"` -
  which modules to "`a2enmod`" before starting.
* `APACHE_SHIB_APACHE_START_SHIB`: default value: `"true"` - whether to
  start Shibboleth or not (valuable for development, as a Shibboleth
  session can be mocked through `SetEnv` in an Apache config).
* `APACHE_SHIB_SHIB_GENERATE_KEY`: default value: `0` - set to `1` to
  allow generating Shibboleth keys at startup.
* `APACHE_SHIB_SHIB_{HOSTNAME,ENTITY_ID}`: Hostname and entity ID used
  for generating Shibboleth  cert.
