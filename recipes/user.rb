app_name = node['app_name']

group app_name do
  action :create
  system true
end

user app_name do
  comment 'BaritoMarket user'
  home "/opt/#{app_name}"
  manage_home true
  system true
  shell '/bin/bash'
  action :create
end
