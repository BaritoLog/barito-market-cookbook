#
# Cookbook:: barito-market-cookbook
# Recipe:: app_puma
#
# Copyright:: 2018, BaritoLog.
#
#

app_name = cookbook_name
user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
install_directory = node[cookbook_name]['install_directory']
puma_config_directory = node[cookbook_name]['puma_config_directory']
puma_pids_directory = node[cookbook_name]['puma_pids_directory']
puma_state_directory = node[cookbook_name]['puma_state_directory']
puma_port = node[cookbook_name]['puma_port']
env = node[cookbook_name]['env']

gem_package 'puma'

[puma_config_directory, puma_state_directory, puma_pids_directory].each do |path|
  directory path do
    owner user
    group group
    mode '0755'
    recursive true
    action :create
  end
end

template "#{puma_config_directory}/puma.#{env}.rb" do
  source "puma_config.rb.erb"
  owner user
  group group
  mode '0644'
  variables directory: "#{install_directory}/BaritoMarket",
            environment: node[cookbook_name]['env'],
            puma_pids_directory: puma_pids_directory,
            puma_state_directory: puma_state_directory,
            puma_port: puma_port
end

include_recipe 'barito_market::app_puma_systemd'
