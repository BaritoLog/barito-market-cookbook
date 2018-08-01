app_name = cookbook_name
release_name = node[cookbook_name]['release_name']
release_file = node[cookbook_name]['release_file']
env = node[app_name]['environment_variables']
barito_market_directory = node[cookbook_name]['barito_market_directory']
install_directory = node[cookbook_name]['install_directory']

git install_directory do
  repository node[cookbook_name]['barito_market_repo']
  destination "#{install_directory}/#{release_name}"
  reference 'master'
  enable_checkout false
  action :sync
end

link "#{install_directory}/#{release_name}/BaritoMarket"  do
  to "#{install_directory}/BaritoMarket"
  action :create
  user app_name
  group app_name
end

template "#{install_directory}/config/application.yml" do
  source 'barito_market_application_yml.erb'
  mode '0644'
  owner app_name
  group app_name
  variables(env)
end

# puma_config app_name do
  # directory "#{install_directory}/config.ru"
  # environment node[cookbook_name]['env']
  # monit false
  # logrotate false
  # thread_min 1
  # thread_max 16
  # workers 2
# end
