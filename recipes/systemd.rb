app_name = cookbook_name
release_name = node[cookbook_name]['release_name']
user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
install_directory = node[cookbook_name]['install_directory']
env = node[cookbook_name]['env']

template "/etc/systemd/system/puma.service" do
  source "systemd.erb"
  owner user
  group group
  mode '0755'
  variables app_name: app_name,
            user: user,
            app_directory: "#{install_directory}/BaritoMarket",
            puma_config_directory: "#{node[cookbook_name]['puma_config_directory']}/puma.#{env}.rb",
            puma_pids_directory: "#{node[cookbook_name]['puma_pids_directory']}/puma.#{env}.pid"
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
