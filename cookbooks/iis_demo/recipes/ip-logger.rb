log "The Windows servers in your organization haved the following FQDN/IP Addresses:-"

search("node","platform:windows").each do |server|
	log "#{server['fqdn']}/#{server['ipaddress']}"
end