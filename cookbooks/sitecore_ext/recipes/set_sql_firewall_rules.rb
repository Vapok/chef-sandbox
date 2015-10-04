firewall_rule_name = "#{node['sqlserver']['server_name']} SQL Static Port"

powershell_script 'Opening Sql Server Port' do
	guard_interpreter :powershell_script
	code "New-NetFirewallRule -DisplayName \"#{firewall_rule_name}\" -Action \"Allow\" -Authentication \"NotRequired\" -Description \"This rule was added automatically by Chef. This rule is remotely managed.\" -Direction \"Inbound\" -Enabled \"True\" -LocalPort #{node['sqlserver']['port']} -Name \"chef-allow-sql\" -Profile \"Any\" -Protocol \"TCP\" -RemoteAddress LocalSubnet"
	not_if <<-ENDNOTIF
		Get-NetFirewallRule -DisplayName \"#{firewall_rule_name}\"
		$rule.Enabled -eq "True"
	ENDNOTIF
end