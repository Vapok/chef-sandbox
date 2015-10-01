#
# Cookbook Name:: sitecore_ext
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# This is used to isntall sitecore on a node.

#http://sqlblog.com/blogs/allen_white/archive/2011/05/19/change-sql-servers-authentication-mode-with-powershell.aspx

service "SQLSERVERAGENT" do 
	action [ :enable, :stop ]
end

service "MSSQLSERVER" do 
	action [ :enable, :start ]
end


powershell_script 'Change Authentication Mode' do
  code <<-EOH
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.Smo')
# Connect to the instance using SMO
$s = new-object ('Microsoft.SqlServer.Management.Smo.Server') '#{node['sqlserver']['server_instance']}'
[string]$mode = $s.Settings.LoginMode
#Change to Mixed Mode
$s.Settings.LoginMode = [Microsoft.SqlServer.Management.Smo.ServerLoginMode]::Mixed
$s.Alter()
EOH
  not_if <<-EOH
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.Smo')
# Connect to the instance using SMO
$s = new-object ('Microsoft.SqlServer.Management.Smo.Server') '#{node['sqlserver']['server_instance']}'
[string]$mode = $s.Settings.LoginMode
$mode -eq "Mixed"
EOH
  notifies  :restart, 'service[MSSQLSERVER]'
  notifies  :start, 'service[SQLSERVERAGENT]'
end


