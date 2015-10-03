
#Sitecore Zip File Binary
default['sitecore']['zip-binary'] = {'toPath' => 'c:\inetpub\wwwroot\sitecore8.zip', 'fromUrl' => 'https://www.dropbox.com/s/cmhicesz49m2c5z/Sitecore8.zip?dl=1'}

#Sitecore License File
default['sitecore']['license-file'] = {'toPath' => 'c:\inetpub\wwwroot\license.xml', 'fromUrl' => 'https://www.dropbox.com/s/tlo5run6t3q2pah/license.xml?dl=1'}

#IIS Settings
default['iis']['sitename'] = 'CHEFPOC'
default['iis']['binding'] = {'hostname' => 'chef-sxp-web2.cloudapp.net','port' => '80'}

#SQL Settings
default['sqlserver']['server_name'] = 'chef-sxp-sql3'
default['sqlserver']['sql_instance'] = 'chef-sxp-sql3'
default['sqlserver']['server_ip'] = '172.16.10.5'
default['sqlserver']['port'] = '1433'
default['sqlserver']['username'] = 'sitecore_user'
default['sqlserver']['password'] = 'foobar123'
default['sqlserver']['db_download_url'] = 'https://www.dropbox.com/s/cmhicesz49m2c5z/Sitecore8.zip?dl=1'
default['sqlserver']['dbs_path'] = 'c:\dbs'

#Mongo Settings
default['mongodb']['install_mongo'] = true
default['mongodb']['hostname'] = 'localhost'

#Sitecore Settings
default['sitecore']['sitename'] = 'CHEFPOC'