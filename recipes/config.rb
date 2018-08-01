app_name = cookbook_name
release_name = node[cookbook_name]['release_name']
release_file = node[cookbook_name]['release_file']
env = node[app_name]['environment_variables']
barito_market_directory = node[cookbook_name]['barito_market_directory']
install_directory = node[cookbook_name]['install_directory']

# directory barito_market_directory do
  # owner app_name
  # group app_name
  # recursive true
  # action :create
# end

git install_directory do
  repository node[cookbook_name]['barito_market_repo']
  destination "#{install_directory}/#{release_name}"
  reference 'master'
  enable_checkout false
  action :sync
end

# tar_extract release_file  do
  # target_dir barito_market_directory
  # download_dir install_directory
  # creates "#{release_name}/Gemfile"
  # user app_name
  # group app_name
# end

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

puma_config app_name do
  directory "#{install_directory}/config.ru"
  environment node[cookbook_name]['env']
  monit false
  logrotate false
  thread_min 1
  thread_max 16
  workers 2
end

# directory "/etc/puma" do
  # owner 'root'
  # group 'root'
  # recursive true
  # action :create
# end

# directory "/var/run/#{app_name}" do
  # owner app_name
  # group app_name
  # mode 0755
  # recursive true
  # action :create
# end

# template "/etc/puma/#{app_name}.rb" do
  # source "puma.conf.erb"
  # owner app_name
  # group app_name
  # variables( app_name: app_name, app_home: app_name )
  # mode "400"
# end


# file "/opt/#{app_name}/#{app_name}/log/#{env['rack_env']}.log" do
  # mode '0644'
  # owner app_name
  # group app_name
# end

# template market_script_location do
  # source "market_script.sh.erb"
  # mode   "0755"
  # owner app_name
  # group app_name
  # variables(
    # app_name: app_name,
    # app_home: app_name,
    # command_name: command_name,
    # rack_env: env['rack_env']
  # )
  # notifies :restart, "service[puma]", :delayed
# end
