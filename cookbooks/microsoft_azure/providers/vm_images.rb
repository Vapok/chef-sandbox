include Azure::Cookbook

action :list do
  mc = setup_management_service

  sms = Azure::VirtualMachineImageManagementService.new
  
  image_names = []
  sms.list_virtual_machine_images.each { |vmimage| image_names.push(vmimage.name) }
  
  if image_names.count > 0
    Chef::Log.debug("Azure VM Image Count: #{image_names.count}")
    counter = 0
    image_names.count.each do |name|
      Chef::Log.debug("Image #{counter}: #{name}")
      counter += 1
    end
    @new_resource.image_list(image_names)
  else
    Chef::Log.debug("=*=*=*= No Azure VM Images Found =*=*=*=")
    @new_resource.image_list(image_names)
  end
  mc.unlink
end