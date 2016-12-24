# php-fpm-symfony
This [Docker php-fpm](https://hub.docker.com/r/jvancoillie/php-fpm-symfony/) image based on [php:fpm](https://github.com/docker-library/php/blob/b66c0fa0286d0abbb8a36653e26e6992bb71b858/7.1/fpm/Dockerfile) includes a ready-to-use composer for symfony project development.

## Run
```bash
$ docker run -d --name php_fpm_symfony jvancoillie/php-fpm-symfony -v path/to/symfony/project::/var/www/html/symfony
```

## With docker-compose

this image is used on my [docker-symfony](https://github.com/jvancoillie/docker-symfony) environment.

```yaml
# docker-compose.yml
version: '2'

services:
    php: #php-fpm container
        image: jvancoillie/php-fpm-symfony 
        ports:
            - 9000:9000
        links:
            - db:mysqldb
            - redis
        volumes:
            - ${SYMFONY_PROJECT_PATH}:/var/www/html/symfony #replace $SYMFONY_PROJECT_PATH in .env file 
            - ./logs/symfony:/var/www/html/symfony/var/logs
    db: #mysql container
        image: mysql
        volumes:
            - ./data/db:/var/lib/mysql #mysql data 
        environment:
            MYSQL_RANDOM_ROOT_PASSWORD: "yes"
            MYSQL_USER: ${MYSQL_USER}
            MYSQL_PASSWORD: ${MYSQL_PASSWORD}
                    
    redis: # redis container
        image: redis:alpine
        ports:
            - 6379:6379

    nginx: #nginx container
        image: jvancoillie/nginx-symfony
        ports:
            - 80:80
        environment: #need for nginx server config
            - FPM_HOST=phpfpmhost      
            - FPM_PORT=9000
            - PROJECT_NAME=symfony      
        links:
            - php:phpfpmhost
        volumes_from:
            - php:ro
        volumes:
            - ./logs/nginx/:/var/log/nginx

```

```bash
$ docker-compose up -d 
```
