include Azure::Cookbook


def initialize(*args)
  super
  @action = :list
  @list_of_images = []
  @image_list = []
end

action :list do
  mc = setup_management_service

  sms = Azure::VirtualMachineImageManagementService.new
     
  if fetch_image_list(sms)
    puts "\nAzure VM Image Count: #{image_names.count}"
    @new_resource.list_of_images(@image_list)
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

  if image_list > 0
    @current_resource.list_of_images = @image_list
  end
end

def fetch_image_list(sms)
  sms.list_virtual_machine_images.each { |vmimage| @image_list.push(vmimage.name) }
  @image_list > 0
end

def image_list
  @image_list
end
