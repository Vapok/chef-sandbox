#
# Cookbook Name:: iis_demo
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

['Web-Server','Web-Common-Http','Web-App-Dev','Web-Mgmt-Tools'].each do |thing|
	include_all = ''
	if thing != 'Web-Server'
		include_all = '-IncludeAllSubFeature'
	end
	powershell_script "install #{thing}" do
		code "add-windowsfeature #{thing} #{include_all}"
		not_if <<-EOH
			$srv=Get-WindowsFeature #{thing}
			$srv.Installed
		EOH
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
	not_if <<-EOH
		$site=Get-Website "Default Web Site"
		$site.State -eq "Stopped"
	EOH
end

node["iis_demo"]["sites"].each do |site_name, site_data|
	site_dir = "#{ENV['SYSTEMDRIVE']}\\inetpub\\wwwroot\\#{site_name}"
	
	directory site_dir

	powershell_script "create app pool for #{site_name}" do |apppool|
		code "New-WebAppPool #{site_name}"
		not_if "C:\\Windows\\System32\\inetsrv\\appcmd.exe list apppool #{site_name}"
	end

	powershell_script "new website for #{site_name}" do |website|
        code <<-EOH
            Import-Module WebAdministration
            if (-not(test-path IIS:\\Sites\\#{site_name})){
              $NewWebsiteParams = @{Name= '#{site_name}';Port= #{site_data["port"]};PhysicalPath= '#{site_dir}';ApplicationPool= '#{site_name}'}
              New-Website @NewWebsiteParams
            }
            elseif ((Get-WebBinding -Name #{site_name}).bindingInformation -ne '*:#{site_data["port"]}:') {
              $CurrentBinding = (Get-WebBinding -Name #{site_name}).bindingInformation
              $BindingParameters = @{Name= '#{site_name}';Binding= $CurrentBinding;PropertyName= 'Port';Value = #{site_data["port"]} }
              Set-WebBinding @BindingParameters
            }
            Get-Website -Name #{site_name} | Where {$_.state -like 'Stopped'} | Start-Website
        EOH
        not_if <<-EOH
        	$site=Get-Website "#{site_name}"
			$site.State -eq "Started"
        EOH
    end

    template "#{site_dir}\\Default.htm" do
        source "Default.htm.erb"
        rights :read, "Everyone"
        variables(
            :site_name => site_name,
            :port => site_data['port']
            )
        notifies :restart, "service[w3svc]"
    end
end