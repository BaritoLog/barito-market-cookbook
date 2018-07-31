app_name = node['app_name']
market_script_location = node['market_script_location']
command_name = node['command_name']
github_repo = 'BaritoLog/BaritoMarket'
release_name = Github.release_name(github_repo)
release_file = Github.release_file(github_repo)
env = node[app_name]['environment_variables']

apt_repository 'brightbox-ruby' do
  uri 'ppa:brightbox/ruby-ng'
end

apt_update

package %w[
  software-properties-common ruby2.5 ruby2.5-dev nodejs build-essential patch
  ruby-dev zlib1g-dev liblzma-dev libpq-dev ruby-switch libffi-dev libcurl4-openssl-dev
]

gem_package 'bundler'

group app_name do
  action :create
  gid 2000
end

user app_name do
  comment 'BaritoMarket user'
  uid 2000
  gid 2000
  home "/opt/#{app_name}"
  manage_home true
  shell '/bin/bash'
  action :create
end

directory "/opt/#{app_name}/#{release_name}" do
  owner app_name
  group app_name
  recursive true
  action :create
end

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

tar_extract release_file  do
  target_dir "/opt/#{app_name}/#{release_name}"
  download_dir "/opt/#{app_name}"
  creates "#{release_name}/Gemfile"
  puts "user for tar: #{app_name}"
  user "#{app_name}"
  group "#{app_name}"
end

link "/opt/#{app_name}/#{app_name}"  do
  to "/opt/#{app_name}/#{release_name}"
  action :create
  user app_name
  group app_name
end

template "/etc/puma/#{app_name}.rb" do
  source "puma.conf.erb"
  owner app_name
  group app_name
  variables( app_name: app_name, app_home: app_name )
  mode "400"
end

template "/opt/#{app_name}/#{app_name}/config/application.yml" do
  source 'barito_market_application_yml.erb'
  mode '0644'
  owner app_name
  group app_name
  variables(env)
end

template market_script_location do
  source "market_script.sh.erb"
  mode   "0755"
  owner app_name
  group app_name
  variables(
    app_name: app_name,
    app_home: app_name,
    command_name: command_name,
    rack_env: env['rack_env']
  )
  notifies :restart, "service[puma]", :delayed
end

template "/etc/systemd/system/puma.service" do
  source "systemd.erb"
  owner app_name
  group app_name
  mode "00644"
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
