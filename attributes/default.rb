cookbook_name = 'barito_market'

default[cookbook_name]['user'] = cookbook_name
default[cookbook_name]['group'] = cookbook_name
default[cookbook_name]['github_repo'] = 'BaritoLog/BaritoMarket'
# default[cookbook_name]['release_name'] = Github.release_name(default[cookbook_name]['github_repo'])
# default[cookbook_name]['release_file'] = Github.release_file(default[cookbook_name]['github_repo'])
# default[cookbook_name]['barito_market_directory'] = "/opt/#{cookbook_name}/#{release_name}"
default[cookbook_name]['barito_market_repo'] = 'https://github.com/BaritoLog/BaritoMarket.git'
default[cookbook_name]['install_directory'] = "/opt/#{cookbook_name}"
default[cookbook_name]['release_name'] = Time.now.strftime('%y%m%d%H%M')
default[cookbook_name]['env'] = 'production'

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

default[normal['app_name']]['environment_variables'] = {
  'db_username' => 'barito_market',
  'db_name' => 'barito_market_production',
  'db_password' => '123456',
  'db_root_password' => '123456',
  'db_port' => 5432,
  'rack_env' => default[cookbook_name]['env'],
  'secret_key_base' => '123456'
}
