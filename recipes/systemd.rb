app_name = node['app_name']
market_script_location = node['market_script_location']
command_name = node['command_name']
github_repo = 'BaritoLog/BaritoMarket'
release_name = Github.release_name(github_repo)
env = node[app_name]['environment_variables']

template "/etc/systemd/system/puma.service" do
  source "systemd.erb"
  owner app_name
  group app_name
  mode "0644"
  variables(
            app_name: app_name,
            app_home: app_name,
            market_script_location: market_script_location
           )
  notifies :run, "execute[systemctl-daemon-reload]", :immediately
  notifies :restart, "service[puma]", :delayed
end

execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
end

service "puma" do
  action :enable
  supports :status => true, :start => true, :restart => true, :stop => true
  provider Chef::Provider::Service::Systemd
end
