#
# Cookbook Name:: sitecore_ext
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# This is used to isntall sitecore databases on a sql server node.

include_recipe 'sitecore'
include_recipe 'windows'

windows_zipfile node['sqlserver']['dbs_path'] do
  source node['sqlserver']['db_download_url']
  action :unzip
end

sitecore_db node['sqlserver']['server'] do
  action [:install, :create_login, :assign_roles]
  site node['iis']['sitename']
  databases [
    { 'name' => 'Sitecore.Core', 'type' => 'core' },
    { 'name' => 'Sitecore.Master', 'type' => 'master' },
    { 'name' => 'Sitecore.Web', 'type' => 'web' },
    { 'name' => 'Sitecore.Sessions', 'type' => 'session' },
    { 'name' => 'Sitecore.Analytics', 'type' => 'analytics' }
  ]
  source_directory "#{node['sqlserver']['dbs_path']}\\Databases"
  
  username node['sqlserver']['username']
  password node['sqlserver']['password']
end