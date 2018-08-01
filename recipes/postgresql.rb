app_name = cookbook_name
version = node['postgresql']['version']
env = node[cookbook_name]['environment_variables']

barito_market_server_install "Postgresql #{version} Server Install" do
  version            version
  hba_file           node['postgresql']['hba_file']
  ident_file         node['postgresql']['ident_file']
  external_pid_file  node['postgresql']['external_pid_file']
  port               env['db_port']
  action :install
end

barito_market_config "Configuring Postgres Installation" do
  version            version
  data_directory     node['postgresql']['data_dir']
  hba_file           node['postgresql']['hba_file']
  ident_file         node['postgresql']['ident_file']
  external_pid_file  node['postgresql']['external_pid_file']
  additional_config  node['postgresql']['config']
  action :modify
end

barito_market_user "Adding user to Postgres Installation" do
  user env['db_username']
  password env['db_password']
  action :create
end

barito_market_access "Configuring Access" do
  version version
  access_type 'host'
  access_db env['db_name']
  access_user env['db_username']
  access_addr 'localhost'
  access_method 'password'
end

barito_market_database env['db_name'] do
  database env['db_name']
  user 'postgres'
end

barito_market_pg_gem 'Install PG Gem' do
  client_version version
  version '1.0.0'
end
