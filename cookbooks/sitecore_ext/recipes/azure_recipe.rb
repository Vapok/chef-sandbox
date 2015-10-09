microsoft_azure = data_bag_item("microsoft_azure", "main")


### VM Image Listing
msazure_expanded_vm_images 'images_listing' do
  management_certificate microsoft_azure['management_certificate'].join("\n")
  subscription_id microsoft_azure['subscription_id']
  action :init
end

ruby_block 'show_images' do
  block do
	    r = resources("msazure_expanded_vm_images[images_listing]")
	    images = r.list_of_images
	    if images.kind_of?(Array) && images.count > 0
	    	images.take(10).each do |image|
	    		puts "From Recipe: Image: #{image}"
	    	end
	    else
	    	puts "Images not loaded?"
	    end
  end
  action :run
end


### VM Disk Listing
msazure_expanded_vm_disks 'disk_listing' do
  management_certificate microsoft_azure['management_certificate'].join("\n")
  subscription_id microsoft_azure['subscription_id']
  action :list
end

ruby_block 'show_disks' do
  block do
	    r = resources("msazure_expanded_vm_disks[disk_listing]")
	    disks = r.list_of_disks
	    if disks.kind_of?(Array) && disks.count > 0
	    	disks.take(10).each do |disk|
	    		p disk
	    	end
	    else
	    	puts "Disks not loaded?"
	    end
  end
  action :run
end
