#
# Cookbook:: barito-market-cookbook
# Recipe:: app
#
# Copyright:: 2018, BaritoLog.
#
#

include_recipe 'barito_market::app_user'
include_recipe 'barito_market::app_install'
include_recipe 'barito_market::app_config'
include_recipe 'barito_market::app_rails'
include_recipe 'barito_market::app_sidekiq'
include_recipe 'barito_market::app_puma'
include_recipe 'barito_market::app_chef_repo'