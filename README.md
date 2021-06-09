# Docker Odoo
   * Version  : 14.0
   * OS       : Ubuntu 20.04TLS

## How to install

  1. Cd to git folder and run command bellow:

     `docker-compose up -d`

     * If you want to build image instead of pull image, you can run command:

       `sudo docker build --no-cache -t docker-odoo`

  2. SSH to docker odoo instance by `user/pwd` : `odoo/odoo`

     `ssh -p 6122 odoo@localhost`

  3. SSH to docker odoo instance by `user/pwd` : `odoo/odoo`

     `ssh -p 6122 odoo@localhost`

  4. Grant access right for script file:

     `cd /scripts && sudo chmod +x odoo_install.sh`

  5. Run scripts to install Odoo and Odoo service

     `sudo ./odoo_install.sh`

## Folder struct:

      │
      └───/var
           │
           └───/log
           │   │
           │   └───/odoo
           │       │   odoo-server.log
           
          /odoo
           │
           └───/custom
           │   |   │   Custom modules here
           │   │
           │   └───/odoo-server
           │       │   Native odoo here

           /etc
           │   odoo-server.conf
           │
           └───/init.d
           │   │  odoo-server // service config


## All command, you can use:
   ### POSTGRES
  * Start postgresql server:

    `sudo service postgresql start`

  * Stop postgresql server:

    `sudo service postgresql stop`

  * Status postgresql server:

    `sudo service postgresql status`

   ### ODOO
  * Start Odoo service:

    `sudo service odoo-server start`

  * Stop Odoo service: 

    `sudo service odoo-server stop`

  * Restart Odoo service: 

    `sudo service odoo-server restart`

## ISSUE
 1. If you cannot access to postgresql, run command to create right role (odoo)

    `sudo su - postgres -c "createuser -s odoo" 2> /dev/null || true`