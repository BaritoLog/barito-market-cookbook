app_name = cookbook_name
user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
install_directory = node[cookbook_name]['install_directory']
puma_config_directory = node[cookbook_name]['puma_config_directory']
puma_pids_directory = node[cookbook_name]['puma_pids_directory']
puma_state_directory = node[cookbook_name]['puma_state_directory']
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
  source "config_puma.rb.erb"
  owner user
  group group
  mode '0755'
  variables directory: "#{install_directory}/BaritoMarket",
            environment: node[cookbook_name]['env'],
            puma_pids_directory: puma_pids_directory,
            puma_state_directory: puma_state_directory
end
