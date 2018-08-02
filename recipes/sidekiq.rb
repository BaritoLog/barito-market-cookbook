install_directory = node[cookbook_name]['install_directory']

apt_update
package 'redis-server'
gem_package 'sidekiq'

template "/etc/systemd/system/sidekiq.service" do
  source "sidekiq.service.erb"
  owner user
  group group
  mode '0755'
  variables app_directory: "#{install_directory}/BaritoMarket"
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
