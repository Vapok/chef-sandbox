


# unlock port in firewall
# this should leverage firewall_rule resource
firewall_rule_name = "#{node['sqlserver']['server_name']} SQL Static Port"

powershell_script 'Opening Sql Server Port' do
	guard_interpreter :powershell_script
	code "netsh advfirewall firewall add rule name=\"#{firewall_rule_name}\" dir=in action=allow protocol=TCP localport=#{node['sqlserver']['port']}"
	not_if <<-ENDNOTIF
		$rule=netsh advfirewall firewall show rule name=\"#{firewall_rule_name}\"
		$rule.Enabled -eq "Yes"
	ENDNOTIF
end