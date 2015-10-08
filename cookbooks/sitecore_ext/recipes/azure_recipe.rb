#include_recipe "microsoft_azure"
microsoft_azure = data_bag_item("microsoft_azure", "main")

images = []

microsoft_azure_vm_images 'images' do
  management_certificate microsoft_azure['management_certificate'].join("\n")
  subscription_id microsoft_azure['subscription_id']
  action :list
  images = :image_list
end

images.each do |image_name|
	puts "Image: #{image_name}"
end

