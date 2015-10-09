# Author : Pete Navarra (vapokrocks@gmail.com)
#-------------------------------------------------------------------------
# Copyright (c) Vapok, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#--------------------------------------------------------------------------

actions :list

attribute :management_certificate, :kind_of => String, :required => true
attribute :subscription_id, :kind_of => String, :required => true
attribute :management_endpoint, :kind_of => String, :default => 'https://management.core.windows.net/'

attr_reader :list_of_images

def initialize(*args)
  super
  @resource_name = :microsoft_azure_vm_images
  @action = :list
end
