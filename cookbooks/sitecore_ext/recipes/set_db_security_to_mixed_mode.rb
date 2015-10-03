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

powershell_script 'Change Authentication Mode' do
	guard_interpreter :powershell_script
	code <<-EOH
		Add-Type -Assembly 'Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91'
		# Connect to the instance using SMO
		$server = new-object ('Microsoft.SqlServer.Management.Smo.Server') '#{node['sqlserver']['sql_instance']}'
		$server.Settings.LoginMode = [Microsoft.SqlServer.Management.Smo.ServerLoginMode]::Mixed
		$server.Alter()
		Stop-Service -Name 'SQLSERVERAGENT'
		Stop-Service -Name 'MSSQLSERVER'
		Start-Service -Name 'MSSQLSERVER'
		Start-Service -Name 'SQLSERVERAGENT'
	EOH

	not_if <<-ENDNOTIF
		Add-Type -Assembly 'Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91'
		# Connect to the instance using SMO
		$sql=new-object ('Microsoft.SqlServer.Management.Smo.Server') '#{node['sqlserver']['sql_instance']}'
		$sqlmode=$sql.Settings.LoginMode
		$sqlmode -eq "Mixed"
	ENDNOTIF
end