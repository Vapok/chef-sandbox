#
# Cookbook Name:: sitecore_ext
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# This is used to isntall sitecore on a node.

include_recipe 'sitecore::iis'
include_recipe 'sitecore'

remote_file 'c:\inetpub\wwwroot\sitecore8.zip' do
  source 'https://www.dropbox.com/s/cmhicesz49m2c5z/Sitecore8.zip?dl=1'
end

remote_file 'c:\inetpub\wwwroot\license.xml' do
  source 'https://www.dropbox.com/s/tlo5run6t3q2pah/license.xml?dl=1'
end

sitecore_cms 'CHEFPOC' do
  source 'c:\inetpub\wwwroot\sitecore8.zip'
  license 'c:\inetpub\wwwroot\license.xml'
  bindings [
    { 'host' => 'chef-sxp-web.cloudapp.net', 'proto' => 'http', 'port' => 80 }
  ]
  # TODO: Pull Username/Passwords from Databag
  connection_strings [
    {
      'name' => 'core',
      'database' => 'Sitecore.Core',
      'user_id' => 'sitecore_user',
      'password' => 'foobar123',
      'data_source' => 'chef-sxp-sql'
    },
    {
      'name' => 'master',
      'database' => 'Sitecore.Master',
      'user_id' => 'sitecore_user',
      'password' => 'foobar123',
      'data_source' => 'chef-sxp-sql'
    },
    {
      'name' => 'web',
      'database' => 'Sitecore.Web',
      'user_id' => 'sitecore_user',
      'password' => 'foobar123',
      'data_source' => 'chef-sxp-sql'
    },
    {
      'name' => 'session',
      'database' => 'Sitecore.Session',
      'user_id' => 'sitecore_user',
      'password' => 'foobar123',
      'data_source' => 'chef-sxp-sql'
    },
    {
      'name' => 'analytics',
      #'connection_string' => 'mongodb://mongodb/analytics'
      'name' => 'analytics',
      'database' => 'Sitecore.Analytics',
      'user_id' => 'sitecore_user',
      'password' => 'foobar123',
      'data_source' => 'chef-sxp-sql'
    }
  ]
end