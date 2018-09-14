#
# Cookbook:: barito-market-cookbook
# Recipe:: app_puma_systemd
#
# Copyright:: 2018, BaritoLog.
#
#

app_name = cookbook_name
release_name = node[cookbook_name]['release_name']
user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
install_directory = node[cookbook_name]['install_directory']
env = node[cookbook_name]['env']

template "/etc/systemd/system/#{app_name}.service" do
  source "puma_systemd.erb"
  owner user
  group group
  mode '0644'
  variables app_name: app_name,
            user: user,
            app_directory: "#{install_directory}/BaritoMarket",
            puma_config_directory: "#{node[cookbook_name]['puma_config_directory']}/puma.#{env}.rb",
            puma_pids_directory: "#{node[cookbook_name]['puma_pids_directory']}/puma.#{env}.pid"
  notifies :run, "execute[systemctl-daemon-reload]", :immediately
  notifies :restart, "service[#{app_name}]", :delayed
end

execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
end

service "#{app_name}" do
  action :enable
  supports :status => true, :start => true, :restart => true, :stop => true
  provider Chef::Provider::Service::Systemd
end
