# BaritoMarketCookbook

## Replication Config

Ensure that these attributes are properly configured for setting up master-slave replication.

```
node['postgresql']['replication']
node['postgresql']['db_master_addr']
node['postgresql']['db_replication_addr']
node['postgresql']['db_replication_username']
node['postgresql']['db_replication_password']
```

## Releasing New Version

We need to do these whenever we release a new version:

1. Run
```
bundle exec berks update
bundle exec berks vendor cookbooks
```

2. Commit and updated `cookbooks` directory
3. Tag the commit that we want to release with format `<APP-VERSION>-<REVISION>`

## Version

This cookbook version will follow barito market version with extra revision indicator suffixed. For example:

- `0.1.1-1` means that this is a revision 1 cookbook that will provision barito market version `0.1.1`