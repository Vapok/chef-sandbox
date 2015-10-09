include Azure::Cookbook


action :list do

  @list_of_images = Array.new
  
  mc = setup_management_service

  sms = Azure::VirtualMachineImageManagementService.new
     
  if fetch_image_list(sms)
    puts "\nAzure VM Image Count: #{@list_of_images.count}"
  else
    puts "\n=*=*=*= No Azure VM Images Found =*=*=*="
  end
  mc.unlink
end

def load_current_resource
  @current_resource = Chef::Resource::MicrosoftAzureVmImages.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.management_certificate(@new_resource.management_certificate)
  @current_resource.subscription_id(@new_resource.subscription_id)
  @current_resource.management_endpoint(@new_resource.management_endpoint)

  if @list_of_images.kind_of?(Array) && @list_of_images.count > 0
    @current_resource.list_of_images = @list_of_images
  end

  @current_resource
end

def fetch_image_list(sms)
  sms.list_virtual_machine_images.each { |vmimage| @list_of_images.push(vmimage.name) }
  @list_of_images.count > 0
end