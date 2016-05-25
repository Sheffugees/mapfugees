# Mapfugees needs directory and wayfinder

## Installation

### Pre-requisites

* [Vagrant](http://vagrantup.com/), version 1.8.1 or greater
* [Composer](http://getcomposer.org/), for the initial install (provisioning *might* handle this; I haven't checked.)

### Virtual-machine installation

Open a terminal, go to the same folder as this README.md and run:

```
$ composer install
$ vagrant up
```

This will start, and completely provision, the VM. If the VM is new it will also fully install the Drupal website. Still on your laptop (*not* ssh'ed into the VM) edit your local hosts file:

```
sudo vim /etc/hosts
```

and add the following line.

```
192.168.56.101 mapfugees.local
```

You should now be able to navigate in a browser to http://mapfugees.local/user and log in with username and password both "admin".

**Note**: the VM provisioning uses a third-party tool called [Puphpet](http://puphpet.com) to build and maintain the dependencies, Vagrantfile etc. If anything fails during provisioning, then that might be your first port of call for googling a solution.

### Native LAMP stack installation

If you really want to, you can install the site on a native (non-virtualized) stack. You're kind of on your own if you do, but look at the importing note below.

## Exporting and importing data

### Exporting

Exporting uses the `default_content` module and `file_entity` to serialize the content of image files for icons.

Unfortunately. `default_content` only exports one Drupal entity at a time. Fortunately, if you export each of the top-level "needs", the referenced solutions and attached icon files etc. will all export too:

```
[laptop] $ vagrant ssh
[vm] $ cd /vagrant
[vm] $ vendor/bin/drush -r `pwd`/web dcer node <NODE_ID>
```

Also unfortunately, `default_content` exports its JSON into the web/ folder, under subfolders based on entity type. So copy the exported files across:

```
[vm] $ mv web/node/* web/profiles/mapfugeeprofile/content/node/
[vm] $ mv web/file/* web/profiles/mapfugeeprofile/content/file/
```

You can discard the `web/user/*.json` file: it's the admin user, which normal Drupal installation creates anyway.

### Importing

The `default_content` module has no importing facility as such, so you should just reinstall the whole site:

```
vendor/bin/drush site-install -y -r `pwd`/web \
  --site-name=Mapfugees \
  --account-name=admin --account-pass=admin \
  --db-url=mysql://d8mapfugees:d8mapfugees@localhost/drupal8_mapfugees
sudo chown www-data web/sites/default/files -R
```

Note that this will lose you any configuration changes, so you should export them using core Drupal config management and add any YAML files you want to keep: see below for brief notes on how to do this.

## Managing configuration

Drupal's config management is a big topic so we don't cover it fully here. In order to get configuration into the install profile, so you can safely reinstall the site, do the following:

### Export configuration

[More info on Drupal.org](https://www.drupal.org/documentation/administer/config), but briefly:

```
[vm] $ vendor/bin/drush -r `pwd`/web config-export
Configuration successfully exported to sites/default/files/<LONG_FOLDER>/sync
```

### Copy configuration into the profile

Make a note of that long folder name above, and copy any files in it that you require, over to `web/profiles/mapfugees/config/install/`.

### Only check in the changes you want

Review the changes you've ended up making using `git diff`, before you reinstall the site. Any new files you find you should probably delete, unless you're sure they contain configuration you want. Full site config export is quite verbose, and dropping that entire folder into the install profile can cause problems during the install phase.