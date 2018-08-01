user = node[cookbook_name]['user']
group = node[cookbook_name]['group']
env = node[cookbook_name]['env']
install_directory = node[cookbook_name]['install_directory']

execute 'run bundle install' do
  user user
  group group
  command 'bundle install'
  cwd "#{install_directory}/BaritoMarket"
end

execute 'setup database' do
  user user
  group group
  command "
    bundle exec RAILS_ENV=#{env} bin/rake db:create && \
    bundle exec RAILS_ENV=#{env} bin/rake db:migrate && \
    bundle exec RAILS_ENV=#{env} bin/rake db:seed && \
  "
  cwd "#{install_directory}/BaritoMarket"
end
