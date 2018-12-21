#
# Cookbook:: barito-market-cookbook
# Recipe:: db_slave
#
# Copyright:: 2018, BaritoLog.
#
#

version = node['postgresql']['version']
env = node[cookbook_name]['environment_variables']
additional_config = node['postgresql']['config']

replication_config = {
  'hot_standby' => node['postgresql']['hot_standby']
}
node.override['postgresql']['config'] = additional_config.merge(replication_config)
additional_config = node['postgresql']['config']

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

barito_market_pg_slave "Configure Slave" do
  version                 version
  db_master_address       node['postgresql']['db_master_address']
  db_replication_username node['postgresql']['db_replication_username']
  db_replication_password node['postgresql']['db_replication_password']
  standby_mode            node['postgresql']['standby_mode']
  action :create
end
