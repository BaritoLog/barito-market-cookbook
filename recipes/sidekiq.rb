apt_update
package 'redis-server'

template "/etc/systemd/system/sidekiq.service" do
  source "sidekiq.service.erb"
  owner user
  group group
  mode '0755'
  variables app_directory: "#{install_directory}/BaritoMarket"
  notifies :run, "execute[systemctl-daemon-reload]", :immediately
  notifies :restart, "service[sidekiq]", :delayed
end

service "sidekiq" do
  action [:enable, :start]
  supports :status => true, :start => true, :restart => true, :stop => true
  provider Chef::Provider::Service::Systemd
end
