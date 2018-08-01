app_name = node['app_name']
github_repo = 'BaritoLog/BaritoMarket'
release_name = Github.release_name(github_repo)
release_file = Github.release_file(github_repo)

directory "/etc/puma" do
  owner 'root'
  group 'root'
  recursive true
  action :create
end

directory "/var/run/#{app_name}" do
  owner app_name
  group app_name
  mode 0755
  recursive true
  action :create
end

# template "/etc/puma/#{app_name}.rb" do
  # source "puma.conf.erb"
  # owner app_name
  # group app_name
  # variables( app_name: app_name, app_home: app_name )
  # mode "400"
# end

template "/opt/#{app_name}/#{app_name}/config/application.yml" do
  source 'barito_market_application_yml.erb'
  mode '0644'
  owner app_name
  group app_name
  variables(env)
end

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
