include_recipe "microsoft_azure"
microsoft_azure = data_bag_item("microsoft_azure", "main")

microsoft_azure_vm_images 'list-images' do
  management_certificate microsoft_azure['management_certificate']
  subscription_id microsoft_azure['subscription_id']
  action :list
end
