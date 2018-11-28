#
# Cookbook:: barito-market-cookbook
# Recipe:: db
#
# Copyright:: 2018, BaritoLog.
#
#

version = node['postgresql']['version']
env = node[cookbook_name]['environment_variables']

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
  additional_config     node['postgresql']['config']
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

barito_market_pg_database "Create Database" do
  database env['db_name']
  user env['db_username']
end

