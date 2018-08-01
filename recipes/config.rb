app_name = cookbook_name
env = node[app_name]['environment_variables']
release_name = node[cookbook_name]['release_name']
install_directory = node[cookbook_name]['install_directory']
user = node[cookbook_name]['user']
group = node[cookbook_name]['group']

directory install_directory do
  owner user
  group user
  recursive true
  action :create
end

git install_directory do
  repository node[cookbook_name]['barito_market_repo']
  destination "#{install_directory}/#{release_name}"
  reference 'master'
  enable_checkout false
  action :sync
end

link "#{install_directory}/BaritoMarket"  do
  to "#{install_directory}/#{release_name}"
  action :create
  user app_name
  group app_name
end

template "#{install_directory}/#{release_name}/config/application.yml" do
  source      'barito_market_application_yml.erb'
  mode        '0644'
  owner       app_name
  group       app_name
  variables   env
end
