#
# Cookbook:: barito-market-cookbook
# Recipe:: db
#
# Copyright:: 2018, BaritoLog.
#
#

version = node['postgresql']['version']
env = node[cookbook_name]['environment_variables']
additional_config = node['postgresql']['config']

if node['postgresql']['replication'] == true
  replication_config = {
    'wal_level' => node['postgresql']['wal_level'],
    'max_wal_senders' => node['postgresql']['max_wal_senders'],
    'archive_mode' => node['postgresql']['archive_mode'],
    'archive_command' => node['postgresql']['archive_command']
  }
  node.override['postgresql']['config'] = additional_config.merge(replication_config)
  additional_config = node['postgresql']['config']
end

barito_market_pg_install "Postgresql #{version} Server Install" do
  version            version
  hba_file           node['postgresql']['hba_file']
  ident_file         node['postgresql']['ident_file']
  external_pid_file  node['postgresql']['external_pid_file']
  port               env['db_port']
  action :install
end

barito_market_pg_config "Configuring Postgres Installation" do
  version               version
  data_directory        node['postgresql']['data_dir']
  hba_file              node['postgresql']['hba_file']
  ident_file            node['postgresql']['ident_file']
  external_pid_file     node['postgresql']['external_pid_file']
  stats_temp_directory  node['postgresql']['stats_temp_directory']
  additional_config     additional_config
  action :modify
end

barito_market_pg_user "Adding user to Postgres Installation" do
  user env['db_username']
  password env['db_password']
  superuser true
  createdb true
  createrole true
  login true
  action :create
end

barito_market_pg_access "Configuring Access" do
  version version
  access_type 'host'
  access_db env['db_name']
  access_user env['db_username']
  access_addr '0.0.0.0/0'
  access_method 'md5'
end

if node['postgresql']['replication'] == true
  barito_market_pg_user "Creating Replication User" do
    user node['postgresql']['db_replication_username']
    password node['postgresql']['db_replication_password']
    createrole true
    replication true
    login true
    action :create
    not_if "psql -U postgres -c \"\\\du\" | grep #{node['postgresql']['db_replication_username']}"
  end

  barito_market_pg_access "Configuring Replication Access" do
    version version
    access_type 'host'
    access_db 'replication'
    access_user node['postgresql']['db_replication_username']
    access_addr "#{node['postgresql']['db_replication_addr']}/32"
    access_method 'trust'
  end

  service "postgresql" do
    action :restart
  end
end

barito_market_pg_database "Create Database" do
  database env['db_name']
  user env['db_username']
end

