app_name = cookbook_name
env = node[app_name]['environment_variables']
release_name = node[cookbook_name]['release_name']
install_directory = node[cookbook_name]['install_directory']
user = node[cookbook_name]['user']
group = node[cookbook_name]['group']

directory install_directory do
  owner user
  group group
  recursive true
  action :create
end

git install_directory do
  repository node[cookbook_name]['barito_market_repo']
  destination "#{install_directory}/#{release_name}"
  reference 'master'
  enable_checkout false
  user user
  group group
  action :sync
end

link "#{install_directory}/BaritoMarket"  do
  to "#{install_directory}/#{release_name}"
  action :create
  user user
  group group
end

template "#{install_directory}/#{release_name}/config/application.yml" do
  source      'barito_market_application_yml.erb'
  mode        '0644'
  owner       user
  group       group
  variables   env
end

execute 'copy tps_config.yml & database.yml' do
  user user
  group group
  command 'cp tps_config.yml.example tps_config.yml && cp database.yml.example database.yml'
  cwd "#{install_directory}/BaritoMarket/config"
end

directory "#{install_directory}/shared" do
  owner user
  group group
  recursive true
  action :create
end
