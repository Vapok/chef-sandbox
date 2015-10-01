#
# Cookbook Name:: sitecore_ext
# Recipe:: 
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# This is used to isntall sitecore on a node.

#http://sqlblog.com/blogs/allen_white/archive/2011/05/19/change-sql-servers-authentication-mode-with-powershell.aspx

#service "SQLSERVERAGENT" do 
	#action [ :enable, :stop ]
#end

#service "MSSQLSERVER" do 
	#action [ :enable, :start ]
#end


powershell_script 'Change Authentication Mode' do
	code <<-EOH
		Add-Type -Assembly 'Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91'
		# Connect to the instance using SMO
		$server = new-object ('Microsoft.SqlServer.Management.Smo.Server') '#{node['sqlserver']['server_instance']}'
		$server.Settings.LoginMode = [Microsoft.SqlServer.Management.Smo.ServerLoginMode]::Mixed
		$server.Alter()
	EOH
	not_if <<-ENDNOTIF
		Add-Type -Assembly 'Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91'
		# Connect to the instance using SMO
		$sql=new-object ('Microsoft.SqlServer.Management.Smo.Server') '#{node['sqlserver']['server_instance']}'
		$sqlmode=$sql.Settings.LoginMode
		$sqlmode -eq "Mixed"
	ENDNOTIF

  #notifies  :restart, 'service[MSSQLSERVER]'
  #notifies  :start, 'service[SQLSERVERAGENT]'
end