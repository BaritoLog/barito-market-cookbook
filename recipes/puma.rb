app_name = cookbook_name
user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
install_directory = node[cookbook_name]['install_directory']
env = node[cookbook_name]['env']

gem_package 'puma'

["#{install_directory}/shared/config", "#{install_directory}/shared/tmp/state", "#{install_directory}/shared/tmp/pids"].each do |path|
  directory path do
    owner user
    group group
    mode '0755'
    recursive true
    action :create
  end
end

template "#{install_directory}/shared/config/puma.#{env}.rb" do
  source "config_puma.rb.erb"
  owner user
  group group
  mode '0755'
  variables directory: "#{install_directory}/BaritoMarket",
            environment: node[cookbook_name]['env'],
            pidfile_directory: "#{install_directory}/shared/tmp/pids",
            state_directory: "#{install_directory}/shared/tmp/state"
  mode "400"
end
