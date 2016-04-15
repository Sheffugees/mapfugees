# Mapfugees needs directory and wayfinder

## Installation

### Pre-requisites

* LAMP stack
* Composer
* Database with access.

### Codebase

```
git clone git@github.com:Sheffugees/mapfugees.git TOPLEVEL
cd TOPLEVEL
composer install
```

### Database and content

Complicated by the fact we need to import content with files attached.

```
cd TOPLEVEL
mkdir -p web/sites/default/files
cp -r import/files web/sites/default/files/import
vendor/bin/drush site-install -y -r `pwd`/web \
  --site-name=Mapfugees \
  --account-name=admin --account-pass=admin \
  --db-url=mysql://d8mapfugees:d8mapfugees@localhost/drupal8_mapfugees
sudo chown www-data web/sites/default/files -R
```

### Troubleshooting

* File importing might need an existing webserver setup, pointing http://mapfugees.local to TOPLEVEL/web. Otherwise you could get errors like:

```
GuzzleHttp\Exception\ClientException' with message
  'Client error: `GET http://mapfugees.local/sites/default/files/import/scales.png` resulted in a `404 Not Found`
response
```

We're working on it! If you still get those errors, ensure you've copied the toplevel `import/files/` folder down into `web/sites/default/files`.
