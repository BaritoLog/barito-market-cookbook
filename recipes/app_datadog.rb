#
# Cookbook:: barito-market-cookbook
# Recipe:: app_datadog
#
# Copyright:: 2018, BaritoLog.
#
#

env = node[cookbook_name]['environment_variables']

template "/etc/datadog-agent/conf.d/process.d/conf.yaml" do
  source "datadog.process.conf.yaml.erb"
  owner 'dd-agent'
  group 'dd-agent'
  mode '0644'
  variables app_name: 'barito-market',
            app_search_string: 'ruby2.5',
            datadog_tags: ['barito-core:barito-market-app']
  notifies :restart, "datadog-agent", :delayed
end
