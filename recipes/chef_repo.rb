user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
chef_repo_placeholder = node[cookbook_name]['chef_repo_placeholder']
chef_repo_directory = node[cookbook_name]['chef_repo_directory']
chef_repo_shared_directory = node[cookbook_name]['chef_repo_shared_directory']

git chef_repo_placeholder do
  user user
  group group
  repository node[cookbook_name]['chef_repo']
  destination "#{chef_repo_directory}"
  reference 'master'
  enable_checkout false
  action :sync
end

execute 'run bundle install' do
  user user
  group group
  command "bundle install --path #{chef_repo_shared_directory}/.local"
  cwd "#{chef_repo_directory}"
end

execute 'run berks install' do
  user user
  group group
  command "BERKSHELF_PATH=#{chef_repo_shared_directory}/.berkshelf bundle exec berks install"
  cwd "#{chef_repo_directory}"
end