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

#Fix the RtBackup Directory
# https://www.dropbox.com/s/o50dckz86vnpz7q/NTFSSecurity.zip?dl=0

#windows_zipfile 'C:\Users\chef\Documents\WindowsPowerShell\Modules\NTFSSecurity' do
#  source "https://www.dropbox.com/s/o50dckz86vnpz7q/NTFSSecurity.zip?dl=1"
#  overwrite true
#  action :unzip
#  not_if {::File.exists?('C:\Users\chef\Documents\WindowsPowerShell\Modules\NTFSSecurity\AlphaFS.dll')}
#end

#powershell_script 'Fix RtBackup Directory' do
#  code <<-EOH
#    Import-Module NTFSSecurity
#    Get-Item C:\\Windows\\System32\\LogFiles\\WMI\\RtBackup | Set-Owner -Account "NT AUTHORITY\\SYSTEM"
#  EOH
#end

if node['mongodb']['install_mongo']
  include_recipe 'mongodb3::install_mongo'
end

include_recipe 'sitecore'

#Download Sitecore Bits Zip
remote_file "#{node['sitecore']['zip-binary']['toPath']}" do
  source "#{node['sitecore']['zip-binary']['fromUrl']}"
end

#Download license file
remote_file "#{node['sitecore']['license-file']['toPath']}" do
  source "#{node['sitecore']['license-file']['fromUrl']}"
end

#Install Sitecore
sitecore_cms "#{node['sitecore']['sitename']}" do
  source "#{node['sitecore']['zip-binary']['toPath']}"
  license "#{node['sitecore']['license-file']['toPath']}"
  bindings [
    { 'host' => node['iis']['binding']['hostname'], 'proto' => 'http', 'port' => node['iis']['binding']['port'] }
  ]

  connection_strings [
    {
      'name' => 'core',
      'database' => 'Sitecore.Core',
      'user_id' => node['sqlserver']['username'],
      'password' => node['sqlserver']['password'],
      'data_source' => node['sqlserver']['sql_instance']
    },
    {
      'name' => 'master',
      'database' => 'Sitecore.Master',
      'user_id' => node['sqlserver']['username'],
      'password' => node['sqlserver']['password'],
      'data_source' => node['sqlserver']['sql_instance']
    },
    {
      'name' => 'web',
      'database' => 'Sitecore.Web',
      'user_id' => node['sqlserver']['username'],
      'password' => node['sqlserver']['password'],
      'data_source' => node['sqlserver']['sql_instance']
    },
    {
      'name' => 'session',
      'database' => 'Sitecore.Session',
      'user_id' => node['sqlserver']['username'],
      'password' => node['sqlserver']['password'],
      'data_source' => node['sqlserver']['sql_instance']
    },
    {
      'name' => 'analytics',
      'connection_string' => "mongodb://#{node['mongodb']['hostname']}/analytics"
    },
    {
      'name' => 'tracking.live',
      'connection_string' => "mongodb://#{node['mongodb']['hostname']}/tracking_live"
    },
    {
      'name' => 'tracking.history',
      'connection_string' => "mongodb://#{node['mongodb']['hostname']}/tracking_history"
    },
    {
      'name' => 'tracking.contact',
      'connection_string' => "mongodb://#{node['mongodb']['hostname']}/tracking_contact"
    },
      {
      'name' => 'reporting',
      'database' => 'Sitecore.Analytics',
      'user_id' => node['sqlserver']['username'],
      'password' => node['sqlserver']['password'],
      'data_source' => node['sqlserver']['sql_instance']
    }
  ]
end

#Set Hosts File for SQL Server
template "#{ENV['windir']}\\System32\\drivers\\etc\\hosts" do |hostfile|
  source "hosts.erb"
end