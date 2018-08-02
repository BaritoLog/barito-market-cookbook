app_name = cookbook_name
user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
install_directory = node[cookbook_name]['install_directory']
env = node[cookbook_name]['env']

gem_package 'puma'

directory "#{install_directory}/shared/config" do
  owner user
  group group
  recursive true
  action :create
end

directory "#{install_directory}/shared/tmp" do
  owner user
  group group
  recursive true
  action :create
end

template "#{install_directory}/shared/config/puma.#{env}.rb" do
  source "config_puma.rb.erb"
  owner user
  group group
  variables directory: "#{install_directory}/BaritoMarket",
            environment: node[cookbook_name]['env'],
            pidfile_path: "#{cookbook_name}/BaritoMarket",
            state_path: "#{cookbook_name}/BaritoMarket"
  mode "400"
end

# directory "/etc/puma" do
  # owner 'root'
  # group 'root'
  # recursive true
  # action :create
# end

# template "/etc/puma/#{app_name}.rb" do
  # source "puma.conf.erb"
  # owner user
  # group group
  # variables directory: "#{install_directory}/BaritoMarket",
            # environment: node[cookbook_name]['env'],
            # pidfile_path: "#{cookbook_name}/BaritoMarket",
            # state_path: "#{cookbook_name}/BaritoMarket"
  # mode "400"
# end
