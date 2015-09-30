#
# Cookbook Name:: sitecore-ext
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'sitecore'

remote_file 'c:/path/to/sitecore7.zip' do
  source 'http://www.example.com/remote_file'
end

remote_file 'c:/path/to/license.xml' do
  source 'http://www.example.com/remote_file'
end


sitecore_cms 'MySite' do
  source 'c:/path/to/sitecore7.zip'
  license 'c:/path/to/license.xml'
  bindings [
    { 'host' => 'example.com', 'proto' => 'http', 'port' => 80 }
  ]
  connection_strings [
    {
      'name' => 'core',
      'database' => 'Sitecore.Core',
      'user_id' => 'sitecore_user',
      'password' => 'foobar123',
      'data_source' => '(local)\SQLEXPRESS'
    },
    {
      'name' => 'master',
      'database' => 'Sitecore.Master',
      'user_id' => 'sitecore_user',
      'password' => 'foobar123',
      'data_source' => '(local)\SQLEXPRESS'
    },
    {
      'name' => 'web',
      'database' => 'Sitecore.Web',
      'user_id' => 'sitecore_user',
      'password' => 'foobar123',
      'data_source' => '(local)\SQLEXPRESS'
    },
    {
      'name' => 'analytics',
      'connection_string' => 'mongodb://mongodb/analytics'
    }
  ]
end

