# Wordpress docker compose

## How to up the new project

1. `git clone https://github.com/soft-industry/WP-Docker-Boilerplate.git`
2. `docker-compose build`
3. `docker-compose up -d`
4. `sudo sh fix-wp-permission.sh web` after you typing your username in the file. Then eject changes

## How to up an existing project


1. `git clone <your-project-repository>`
2. `docker-compose build`
3. `docker-compose up -d`


## Command reference

* `docker-compose exec db bash` will open shell on the running db container.
* `docker-compose stop` will stop running containers.
* `docker-compose rm db` will erase built db container. So when you run `docker-compose up` it will be built again, and the initial dump will apply.
* `$ docker exec some-mysql-contaner sh -c 'exec mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" db_name' > /some/path/on/your/host/db_name.sql` will make dump from `some-mysql-contaner` and database `db_name` into local file

## To install docker compose

https://docs.docker.com/compose/install/