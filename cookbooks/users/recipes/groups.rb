search(:groups,"*:*").each do |group_data|
	group group_data["id"] do |group|
		members group_data["members"]		
	end
end