chef_gem 'rubysl-prettyprint' do
  version '1.0.1'
  action :install
end

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
	    	pp disks
	    else
	    	puts "Disks not loaded?"
	    end
  end
  action :run
end

### VM Get Disk Info for Disk Name
msazure_expanded_vm_disks "get_a_disk" do
  management_certificate microsoft_azure['management_certificate'].join("\n")
  subscription_id microsoft_azure['subscription_id']
  diskname lazy {
	    r = resources("msazure_expanded_vm_disks[disk_listing]")
	    disks = r.list_of_disks
	    diskname = ''
	    if disks.kind_of?(Array) && disks.count > 0
	    	disk = disks.first
	    	diskname = disk.name
	    end
	    diskname
  }
  action :get
end

ruby_block 'show_disk' do
  block do
	    r = resources("msazure_expanded_vm_disks[get_a_disk]")
	    info = r.diskinfo
	    if info.kind_of?(Array) && info.count > 0
	    	pp info
	    else
	    	puts "Disk #{r.diskname} not Found"
	    end
  end
  action :run
end

msazure_expanded_vm_disks "get_a_disk2" do
  management_certificate microsoft_azure['management_certificate'].join("\n")
  subscription_id microsoft_azure['subscription_id']
  diskname "VapokDev-VapokDev-0-201502261839060590"
  action :get
end

ruby_block 'show_disk2' do
  block do
	    r = resources("msazure_expanded_vm_disks[get_a_disk2]")
	    info = r.diskinfo
	    if info.kind_of?(Array) && info.count > 0
	    	pp info
	    else
	    	puts "Disk #{r.diskname} not Found"
	    end
  end
  action :run
end











