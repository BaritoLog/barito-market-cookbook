#
# Cookbook:: barito-market-cookbook
# Resource:: pg_slave
#
# Copyright:: 2018, BaritoLog.
#
#

property :version, String
property :standby_mode, String, required: true, default: 'on'
property :db_master_address, String
property :db_replication_username, String
property :db_replication_password, String
property :cookbook, String

action :create do
  bash 'pg_basebackup from db master' do
    code <<-EOH
      sudo service postgresql stop
      sudo -u postgres rm -rf /var/lib/postgresql/#{new_resource.version}/main
      sudo -u postgres pg_basebackup -h #{new_resource.db_master_address} -D /var/lib/postgresql/#{new_resource.version}/main -U #{new_resource.db_replication_username} -v -P
      touch /var/log/fake.txt
    EOH
    timeout 18000
    not_if { ::File.exists?('/var/log/fake.txt') }
  end

  path = "/var/lib/postgresql/#{new_resource.version}/main/recovery.conf"
  template path do
    cookbook new_resource.cookbook
    source 'recovery.conf.erb'
    owner 'postgres'
    group 'postgres'
    mode '0644'
    variables(
      standby_mode:     new_resource.standby_mode,
      primary_conninfo: "host=#{new_resource.db_master_address} port=5432 user=#{new_resource.db_replication_username} password=#{new_resource.db_replication_password}",
      trigger_file:     '/tmp/postgresql.trigger.5432'
    )
    notifies :start, 'service[postgresql]', :immediately
  end

  service "postgresql" do
    action :nothing
  end

end
