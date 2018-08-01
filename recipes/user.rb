group node[cookbook_name]['group'] do
  system true
end

user node[cookbook_name]['user'] do
  comment "#{node[cookbook_name]['user']} user"
  group node[cookbook_name]['group']
  system true
  shell '/sbin/nologin'
end
