#
# Cookbook Name:: iis_demo
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

['Web-Server','Web-Common-Http -IncludeAllSubFeature','Web-App-Dev -IncludeAllSubFeature','Web-Mgmt-Tools -IncludeAllSubFeature'].each do |thing|
	powershell_script "install #{thing}" do
		code "add-windowsfeature #{thing}"
	end
end

service "w3svc" do 
	action [ :enable, :start ]
end

#cookbook_file 'c:\inetpub\wwwroot\Default.htm' do
#	source node["iis_demo"]["indexfile"]
#	rights :read, "Everyone"
#end

powershell_script "disable deafult site" do |sitedisable|
	code 'get-website "Default Web Site*" | where {$_.state -ne "Stopped"} | Stop-Website'
end

node["iis_demo"]["sites"].each do |sitename, site_data|
	site_dir = File.join(ENV['SYSTEMDRIVE'],'inetpub','wwwroot',sitename)
	directory site_dir
end