#
# Cookbook:: barito-market-cookbook
# Recipe:: app_sidekiq
#
# Copyright:: 2018, BaritoLog.
#
#

user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
install_directory = node[cookbook_name]['install_directory']
env = node[cookbook_name]['env']

apt_update
package 'redis-server'
gem_package 'sidekiq'

template "/etc/systemd/system/sidekiq.service" do
  source "sidekiq.service.erb"
  owner user
  group group
  mode '0644'
  variables app_directory: "#{install_directory}/BaritoMarket",
            user: user,
            env: env,
            sidekiq_conf: "#{install_directory}/BaritoMarket/config/sidekiq.yaml"
  notifies :run, "execute[systemctl-daemon-reload]", :immediately
  notifies :restart, "service[sidekiq]", :delayed
end

execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
end

service "sidekiq" do
  action [:enable, :start]
  supports :status => true, :start => true, :restart => true, :stop => true
  provider Chef::Provider::Service::Systemd
end
