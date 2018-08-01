apt_repository 'brightbox-ruby' do
  uri 'ppa:brightbox/ruby-ng'
end

apt_update

package %w[
  software-properties-common ruby2.5 ruby2.5-dev nodejs build-essential patch
  ruby-dev zlib1g-dev liblzma-dev libpq-dev ruby-switch libffi-dev libcurl4-openssl-dev
]

gem_package 'bundler'

directory "/opt/#{app_name}/#{release_name}" do
  owner app_name
  group app_name
  recursive true
  action :create
end

tar_extract release_file  do
  target_dir "/opt/#{app_name}/#{release_name}"
  download_dir "/opt/#{app_name}"
  creates "#{release_name}/Gemfile"
  user app_name
  group app_name
end

link "/opt/#{app_name}/#{app_name}"  do
  to "/opt/#{app_name}/#{release_name}"
  action :create
  user app_name
  group app_name
end

