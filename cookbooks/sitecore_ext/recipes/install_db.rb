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

windows_zipfile 'c:/dbs' do
  source 'https://www.dropbox.com/s/cmhicesz49m2c5z/Sitecore8.zip?dl=1'
  action :unzip
end

sitecore_db 'CHEF-SXP-SQL' do
  action [:install, :create_login, :assign_roles]
  site 'CHEFPOC'
  databases [
    { 'name' => 'Sitecore.Core', 'type' => 'core' },
    { 'name' => 'Sitecore.Master', 'type' => 'master' },
    { 'name' => 'Sitecore.Web', 'type' => 'web' },
    { 'name' => 'Sitecore.Sessions', 'type' => 'session' },
    { 'name' => 'Sitecore.Analytics', 'type' => 'analytics' }
  ]
  source_directory 'c:/dbs/Databases'
  
  #TODO: Add this to a databag

  username 'sitecore_user'
  password 'foobar123'
end