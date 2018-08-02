apt_update
package 'redis-server'

service "redis" do
  action [:enable, :start]
  supports :status => true, :start => true, :restart => true, :stop => true
  provider Chef::Provider::Service::Systemd
end
