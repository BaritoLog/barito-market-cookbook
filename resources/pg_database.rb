#
# Cookbook:: barito-market-cookbook
# Resource:: pg_database
#
# Copyright:: 2018, BaritoLog.
#
#

property :database,  String, name_property: true
property :user,      String, default: 'postgres', required: true
property :encoding,  String, default: 'UTF-8'
property :locale,    String, default: 'C.UTF-8'

action :create do
  createdb = 'createdb'
  createdb << " -U postgres"
  createdb << " -E #{new_resource.encoding}" if new_resource.encoding
  createdb << " -l #{new_resource.locale}" if new_resource.locale
  createdb << " -O #{new_resource.user}"

  # see https://stackoverflow.com/questions/18870775/how-to-change-the-template-database-collection-coding-on-postgresql
  createdb << " -T template0"

  createdb << " #{new_resource.database}"

  bash "Create Database #{new_resource.database}" do
    code createdb
    user 'postgres'
    not_if { database_exists?(new_resource.user, new_resource.database) }
  end
end

action_class do
  include PostgresqlCookbook::Helpers
end
