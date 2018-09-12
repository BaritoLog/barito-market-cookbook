#
# Cookbook:: barito-market-cookbook
# Recipe:: app_install
#
# Copyright:: 2018, BaritoLog.
#
#

apt_repository 'brightbox-ruby' do
  uri 'ppa:brightbox/ruby-ng'
end

if Chef::VERSION.split('.')[0].to_i > 12
  apt_update
else
  apt_update 'apt update' do
    action :update
  end
end

package %w(software-properties-common ruby2.5 ruby2.5-dev nodejs build-essential patch zlib1g-dev liblzma-dev libffi-dev libcurl4-openssl-dev)

gem_package 'bundler'

barito_market_pg_gem 'Install PG Gem' do
  client_version node['postgresql']['version']
end
