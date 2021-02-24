---
admin: true
---
# Flight Login API(8) - Cluster Login API Daemon

## Overview

Operates a single sign on server for flight application running on your
cluster.

The service will be hosted at: `https://example.com/login/api/v0`

## Configuration

The `login-api` uses browser cookies to manage user's login sessions. Before
starting the application the `sso_cookie_domain` needs to be configured.

This should be the _fully qualified domain name_ to where the web applications
are being hosted.

Please follow the prompts from the `flight configure` command to configure
the application:

~~~
$ flight configure login-api
... follow the prompts to set the sso_cookie_domain ...
~~~

*NOTE: Reinstalling flight-login-api*

The application will do its best to use the previous configuration after a
reinstall, however there are cases where it may need to be reconfigured.

Please use the `--force` flag to apply the old configuration:

~~~
$ flight configure login-api --force
~~~

## Starting the service

The `login-api` can be started with:

~~~
$ flight service start login-api
Starting 'login-api' service:

   > OK Starting service 

The 'login-api' service has been started.
~~~

## Stopping the service

The `login-api` can be stopped with:

~~~
$ flight service stop login-api
Stopping 'login-api' service:

   > OK Stopping service 

The 'login-api' service has been stopped.
~~~

## Checking the service status

The service status of `login-api` can be checked with:

~~~
$ flight service status login-api
~~~

## Trouble shooting

There are various logs which can help diagnose issue with the service.

The first place to check is the `puma` logs:

```
$ cat /opt/flight/var/log/login-api/puma.log
```

Alternatively, the various service log files are located here:

```
$ cat /opt/flight/var/log/service/login-api.start.log
$ cat /opt/flight/var/log/service/login-api.stop.log
$ cat /opt/flight/var/log/service/login-api.restart.log
$ cat /opt/flight/var/log/service/login-api.reload.log
```
