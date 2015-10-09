#include_recipe "microsoft_azure"
microsoft_azure = data_bag_item("microsoft_azure", "main")

microsoft_azure_vm_images 'images_listing' do
  management_certificate microsoft_azure['management_certificate'].join("\n")
  subscription_id microsoft_azure['subscription_id']
  action :list
end

ruby_block 'show_images' do
  block do
	    r = resources("microsoft_azure_vm_images[images_listing]")
	    images = r.list_of_images
	    if images.kind_of?(Array) && images.count > 0
	    	images.each do |image|
	    		puts "Image: #{image}"
	    	end
	    else
	    	puts "Images not loaded?"
	    end
  end
  action :run
  notifies :list, 'microsoft_azure_vm_images[images_listing]', :immediately
end