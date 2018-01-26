# apache2-shib

Docker image for Apache2.4 + Shibboleth2 (SP).

## Usage

Mount your Apache config to `/etc/sites-enabled/000-default.conf` (more config files can be mounted under `/etc/sites-enabled/`).

Mount any Shibboleth config files under `/etc/shibboleth/` to override the default config. Don't forget to mount your own keys for Shibboleth to use.


*Available environment variables:*

* `APACHE_SHIB_APACHE_MODULES_TO_START`: default value: `"shib2 ssl"` - which modules to "`a2enmod`" before starting.
* `APACHE_SHIB_APACHE_START_SHIB`: default value: `"true"` - whether to start Shibboleth or not (valuable for development, as a Shibboleth session can be mocked through `SetEnv` in an Apache config).

*WARNING: Under development*

