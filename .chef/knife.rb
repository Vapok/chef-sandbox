# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "vapok"
client_key               "#{current_dir}/vapok.pem"
validation_client_name   "vapok-validator"
validation_key           "#{current_dir}/vapok-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/vapok"
cookbook_path            ["#{current_dir}/../cookbooks"]

if ENV['USERDOMAIN'] != 'VAPOK'
	http_proxy 'pnavarra:Dragon111@proxy1.russell.com:8080'
	https_proxy 'pnavarra:Dragon111@proxy1.russell.com:8080'
end
