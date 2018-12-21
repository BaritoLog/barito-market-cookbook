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
accesses = []

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
  notifies :restart, "service[postgresql]", :delayed
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

accesses << {
  'type' => 'host',
  'db' => env['db_name'],
  'user' => env['db_username'],
  'address' => '0.0.0.0/0',
  'method' => 'md5'
}

if node['postgresql']['replication'] == true
  barito_market_pg_user "Creating Replication User" do
    user node['postgresql']['db_replication_username']
    password node['postgresql']['db_replication_password']
    replication true
    action :create
  end

  accesses << {
    'type' => 'host',
    'db' => 'replication',
    'user' => node['postgresql']['db_replication_username'],
    'address' => "#{node['postgresql']['db_replication_addr']}/32",
    'method' => 'trust'
  }
end

barito_market_pg_access "Configuring Access" do
  version version
  accesses accesses
  notifies :restart, "service[postgresql]", :delayed
end

barito_market_pg_database "Create Database" do
  database env['db_name']
  user env['db_username']
end

service "postgresql" do
  action :nothing
  supports :status => true, :start => true, :restart => true, :stop => true
end
