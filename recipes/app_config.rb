#
# Cookbook:: barito-market-cookbook
# Recipe:: app_config
#
# Copyright:: 2018, BaritoLog.
#
#

app_name = cookbook_name
user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
release_name = node[cookbook_name]['release_name']
ssh_directory = node[cookbook_name]['ssh_directory']
install_directory = node[cookbook_name]['install_directory']
shared_directory = node[cookbook_name]['shared_directory']
shared_log_directory = node[cookbook_name]['shared_log_directory']
chef_repo_placeholder = node[cookbook_name]['chef_repo_placeholder']
chef_repo_directory = node[cookbook_name]['chef_repo_directory']
chef_repo_shared_directory = node[cookbook_name]['chef_repo_shared_directory']
private_keys_directory = node[cookbook_name]['private_keys_directory']
env = node[app_name]['environment_variables']

[ssh_directory, install_directory, shared_directory, shared_log_directory, private_keys_directory, chef_repo_placeholder, chef_repo_directory, chef_repo_shared_directory].each do |path|
  directory path do
    owner user
    group group
    mode '0755'
    recursive true
    action :create
  end
end

file "#{ssh_directory}/known_hosts" do
  mode '0644'
  owner user
  group group
end

git install_directory do
  repository node[cookbook_name]['barito_market_repo']
  destination "#{install_directory}/#{release_name}"
  reference 'master'
  enable_checkout false
  user user
  group group
  action :sync
end

directory "#{install_directory}/#{release_name}/log" do
  recursive true
  action :delete
end

link "#{install_directory}/#{release_name}/log" do
  to "#{shared_log_directory}"
  action :create
  user user
  group group
end

link "#{install_directory}/BaritoMarket"  do
  to "#{install_directory}/#{release_name}"
  action :create
  user user
  group group
end

# Keep only 5 latest deployments (exclude shared folder)
execute 'ls -1t -Ishared | tail -n +6 | xargs rm -rf' do
  user user
  group group
  cwd "#{install_directory}"
end

template "#{install_directory}/#{release_name}/config/application.yml" do
  source      'barito_market_application_yml.erb'
  mode        '0644'
  owner       user
  group       group
  variables   env
end

execute 'copy tps_config.yml & database.yml' do
  user user
  group group
  command 'cp tps_config.yml.example tps_config.yml && cp database.yml.example database.yml'
  cwd "#{install_directory}/BaritoMarket/config"
end

template '/etc/logrotate.d/barito-market' do
  source 'logrotate/barito-market.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables directory: "#{shared_log_directory}"
end
