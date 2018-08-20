cookbook_name = 'barito_market'

default[cookbook_name]['user'] = cookbook_name
default[cookbook_name]['group'] = cookbook_name
default[cookbook_name]['release_name'] = Time.now.strftime('%y%m%d%H%M')
default[cookbook_name]['barito_market_repo'] = 'https://github.com/BaritoLog/BaritoMarket.git'
default[cookbook_name]['chef_repo'] = 'https://github.com/BaritoLog/chef-repo.git'
default[cookbook_name]['install_directory'] = "/opt/#{cookbook_name}"
default[cookbook_name]['chef_repo_placeholder'] = "/opt/chef-repo/"
default[cookbook_name]['chef_repo_directory'] = "/opt/chef-repo/chef-repo"
default[cookbook_name]['chef_repo_shared_directory'] = "/opt/chef-repo/shared"
default[cookbook_name]['shared_directory'] = "#{default[cookbook_name]['install_directory']}/shared"
default[cookbook_name]['private_keys_directory'] = "#{default[cookbook_name]['shared_directory']}/private_keys"
default[cookbook_name]['env'] = 'production'

default['postgresql']['version'] = '10'
default['postgresql']['config_dir'] = "/etc/postgresql/#{node['postgresql']['version']}/main"
default['postgresql']['data_dir'] = "/var/lib/postgresql/#{node['postgresql']['version']}/main"
default['postgresql']['external_pid_file'] = "/var/run/postgresql/#{node['postgresql']['version']}-main.pid"
default['postgresql']['hba_file'] = "#{node['postgresql']['config_dir']}/pg_hba.conf"
default['postgresql']['ident_file'] = "#{node['postgresql']['config_dir']}/pg_ident.conf"

default['postgresql']['config'] = {
  'listen_addresses' => '*',
  'timezone' => 'Asia/Jakarta',
  'log_timezone' => 'Asia/Jakarta',
  'dynamic_shared_memory_type' => 'posix',
  'log_line_prefix' => '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h ',
  'track_counts' => 'on',
  'max_connections' => 1000
}

default[cookbook_name]['puma_directory'] = "#{default[cookbook_name]['install_directory']}/shared/puma"
default[cookbook_name]['puma_config_directory'] = "#{default[cookbook_name]['puma_directory']}/config"
default[cookbook_name]['puma_tmp_directory'] = "#{default[cookbook_name]['puma_directory']}/tmp"
default[cookbook_name]['puma_pids_directory'] = "#{default[cookbook_name]['puma_tmp_directory']}/pids"
default[cookbook_name]['puma_state_directory'] = "#{default[cookbook_name]['puma_tmp_directory']}/state"

default[cookbook_name]['environment_variables'] = {
  'rails_serve_static_files' => true,
  'db_username' => 'barito_market',
  'db_host' => 'localhost',
  'db_password' => '123456',
  'db_root_password' => '123456',
  'db_port' => 5432,
  'db_pool' => 5,
  'db_timeout' => 5000,
  'provision_available_instances' => 'yggdrasil,consul,zookeeper,kafka,elasticsearch,barito-flow-producer,barito-flow-consumer,kibana',
  'app_groups' => 'barito',
  'market_end_point' => 'http://market.barito.local/',
  'router_protocol' => 'http',
  'router_domain' => 'router.barito.local',
  'viewer_protocol' => 'http',
  'viewer_domain' => 'viewer.barito.local',
  'sauron_host' => '127.0.0.1:3000',
  'container_private_keys_dir' => "#{default[cookbook_name]['private_keys_directory']}",
  'container_private_key' => 'barito',
  'container_username' => 'ubuntu',
  'chef_repo_dir' => "#{default[cookbook_name]['chef_repo_directory']}",
  'default_consul_port' => '8500',
  'secret_key_base' => '123456',
  'datadog_api_key' => 'datadogapikey',
  'datadog_integration' => 'true',

  'rack_env' => default[cookbook_name]['env'],
  'db_name' => 'barito_market_production',
  'enable_cas_integration' => true,
  'timestamp_format' => '%d-%m-%Y %H:%M' 
}
