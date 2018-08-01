app_name = cookbook_name
user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
install_directory = node[cookbook_name]['install_directory']

gem_package 'puma'

directory "/etc/puma" do
  owner 'root'
  group 'root'
  recursive true
  action :create
end

template "/etc/puma/#{app_name}.rb" do
  source "puma.conf.erb"
  owner user
  group group
  variables directory: "#{install_directory}/BaritoMarket",
            environment: node[cookbook_name]['env']
            
  mode "400"
end
