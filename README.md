# Zend Server 6 Vagrant Box

This Vagrant setup configures an Ubuntu 12.04 (Precise) 64-bit box with:
* Zend Server 6
* PHP 5.3 (including APC & Solr extensions)
* MySQL 5.5

## Requirements

To use this package you'll need:

* Vagrant: http://www.vagrantup.com/
* VirtualBox: https://www.virtualbox.org/

## Quick Start

1. Clone this repository onto your machine. It doesn't matter much where, but if you are going to use Vagrant machines a lot, maybe create a folder for it and have this live within that folder
1. On the command line, navigate to the 'vagrant' folder
1. Run `vagrant up`. The first time you run this, the VM will 'provision' all the requirements. It will take 5-10 mins depending on your PC and internet speed

    ```cd vagrant; vagrant up```

1. Once provisioning is completed, hit http://localhost:10081 and setup ZendServer (it'll ask you to set a password, agree to terms etc)

## Forwarded Ports

The following ports on your host machine will be forwarded to the VM
* 8080 => 80 (Webapp)
* 10081 => 10081 (Zend Server Console)
* 10082 => 10082 (Zend Server HTTPS Console)
* 3307 => 3306 (MySQL)

## Shared Folders

Out of the box, the `app` directory from this repository is shared as `/home/vagrant/app` in the VM. You can change this easily by modifying the line in the `Vagrantfile`. The format of this config line is alias, path-on-guest, local-path-on-host

    config.vm.share_folder "v-web-app", "/home/vagrant/app", "../app"

To have the VM serve web content from another folder, simply change `"../app"` to be a valid path on your local PC.

## MySQL

MySQL is available from your host-PC on port 3307 (to avoid conflict with any local MySQL server you might have). If you prefer, you can change this in the `Vagrantfile` to 3306. The guest-OS provides MySQL on 3306 on localhost, so the default settings for web apps can be simply:

* Host: localhost
* User: root
* Password: &lt;none&gt;


## Apache

Apache is configured with the MPM-ITK module with document root set to
`/home/vagrant/app`.

Once provisioning is completed, if you have left the Shared Folder setting as per the default you should be able to test the VM by accessing the PHPINFO or APC files:

* http://localhost:8080/phpinfo.php
* http://localhost:8080/apc.php

## Vagrant

* Vagrant command line tools make it easy to manage your VM(s). For a summary, try: http://earlyandoften.wordpress.com/2012/09/06/vagrant-cheatsheat/
eg. if you ever need to access the command line of the VM you are running, just use `vagrant ssh`

## Credits

Based on Phil Browns vagrant-zend-server - https://github.com/philBrown/vagrant-zend-server
