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
