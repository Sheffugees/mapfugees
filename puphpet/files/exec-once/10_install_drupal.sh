#!/bin/bash
# @file
# Install Drupal

cd /vagrant/web
../vendor/bin/drush site-install -y --account-name=admin --account-pass=admin --site-name=Mapfugees --db-url=mysql://d8mapfugees:d8mapfugees@localhost/drupal8_mapfugees
