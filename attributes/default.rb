cookbook_name = 'barito_market'

default[cookbook_name]['user'] = cookbook_name
default[cookbook_name]['group'] = cookbook_name
default[cookbook_name]['github_repo'] = 'BaritoLog/BaritoMarket'
default[cookbook_name]['barito_market_repo'] = 'https://github.com/BaritoLog/BaritoMarket.git'
default[cookbook_name]['install_directory'] = "/opt/#{cookbook_name}"
default[cookbook_name]['release_name'] = Time.now.strftime('%y%m%d%H%M')
default[cookbook_name]['env'] = 'production'

default[cookbook_name]['puma_directory'] = "#{default[cookbook_name]['install_directory']}/shared/puma"
default[cookbook_name]['puma_config_directory'] = "#{default[cookbook_name]['puma_directory']}/config"
default[cookbook_name]['puma_tmp_directory'] = "#{default[cookbook_name]['puma_directory']}/tmp"
default[cookbook_name]['puma_pids_directory'] = "#{default[cookbook_name]['puma_tmp_directory']}/pids"
default[cookbook_name]['puma_state_directory'] = "#{default[cookbook_name]['puma_tmp_directory']}/state"

default['postgresql']['version'] = '10'
default['postgresql']['config_dir'] = "/etc/postgresql/#{node['postgresql']['version']}/main"
default['postgresql']['hba_file'] = "#{node['postgresql']['config_dir']}/pg_hba.conf"
default['postgresql']['ident_file'] = "#{node['postgresql']['config_dir']}/pg_ident.conf"
default['postgresql']['external_pid_file'] = "/var/run/postgresql/#{node['postgresql']['version']}-main.pid"
default['postgresql']['data_dir'] = "/var/lib/postgresql/#{node['postgresql']['version']}/main"

default['postgresql']['config'] = {
  'listen_addresses' => '*',
  'unix_socket_directories' => '/var/run/postgresql',
  'timezone' => 'Asia/Jakarta',
  'log_timezone' => 'Asia/Jakarta',
  'dynamic_shared_memory_type' => 'posix',
  'checkpoint_segments' => 16,
  'log_line_prefix' => '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h ',
  'track_counts' => 'on',
  'max_connections' => 1000
}

default[cookbook_name]['environment_variables'] = {
  'db_username' => 'barito_market',
  'db_name' => 'barito_market_production',
  'db_password' => '123456',
  'db_root_password' => '123456',
  'db_port' => 5432,
  'db_host' => 'localhost',
  'db_pool' => 5,
  'db_timeout' => 5000,
  'rack_env' => default[cookbook_name]['env'],
  'enable_cas_integration' => true,
  'provision_available_instances' => 'yggdrasil,consul,zookeeper,kafka,elasticsearch,barito-flow-producer,barito-flow-consumer,kibana',
  'app_groups' => 'barito',
  'secret_key_base' => '123456'
}
