gem_package 'puma'

directory "/etc/puma" do	
  owner 'root'	
  group 'root'	
  recursive true	
  action :create	
end

template "/etc/puma/#{app_name}.rb" do	
  source "puma.conf.erb"	
  owner app_name	
  group app_name	
  variables( app_name: app_name, app_home: app_name )	
  mode "400"	
end
