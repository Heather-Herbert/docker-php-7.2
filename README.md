This is an Apache+PHP 7.2 Docker image based of the UofA 7.3 docker image

## Usage:

Update your docker-compose.yml with:

```
web:
 image: heatherherbert/php-7.32
```

### Tips and tricks:

Open a bash terminal into the container:
```bash
docker exec -it <application_name>_web_1 bash
```

Log files:
```bash
# apache
tail -f /etc/httpd/log/error_log
# xdebug
tail -f /tmp/xdebug
```

Using Supervisor (see <http://supervisord.org/running.html>)
```bash
# restart apache
supervisorctl restart httpd
# restart php-fpm
supervisorctl restart php-fpm
```

Turn off Xdebug
```bash
mv /etc/php.d/15-xdebug.ini /etc/php.d/15-xdebug.disabled
```

Turn Xdebug back on
```bash
mv /etc/php.d/15-xdebug.disabled /etc/php.d/15-xdebug.ini
```

Status
```bash
# Chec loaded extensions
php --ini
# Check version
php -v
# Check php-fpm is running
php-fpm
# Check Apache Config
httpd -t
```

Xdebug configuration for VSCode
```
{
    "name": "Listen for XDebug",
    "type": "php",
    "request": "launch",
    "log": true,
    "pathMappings": {
        "/var/www": "${workspaceRoot}"
    },
    "port": 9000,
    "xdebugSettings": {
        "max_data": -1
    }
},
```
The port can be changed by setting the env variable HOST_PORT_XDEBUG on the container.
