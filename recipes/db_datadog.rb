#
# Cookbook:: barito-market-cookbook
# Recipe:: db_datadog
#
# Copyright:: 2018, BaritoLog.
#
#

env = node[cookbook_name]['environment_variables']

template "/etc/datadog-agent/conf.d/postgres.d/conf.yaml" do
  source "datadog.postgres.conf.yaml.erb"
  owner 'dd-agent'
  group 'dd-agent'
  mode '0644'
  variables db_username: env['db_username'],
            db_password: env['db_password'],
            db_name: env['db_name'],
            datadog_tags: ['barito-core:barito-market-db']
  notifies :restart, "datadog-agent", :delayed
end
