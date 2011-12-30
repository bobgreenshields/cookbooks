#
# Cookbook Name:: samba
# Provider:: user
#
# Copyright:: 2010, Opscode, Inc <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut


action :install do
	if @module.exists
		Chef::Log.info("install: module #{new_resource.name} is already loaded")
#		Chef::Log.info("install: NO modprobe on #{new_resource.name}")
	else
		Chef::Log.info("install: module #{new_resource.name} is not loaded")
#		Chef::Log.info("install: execute modprobe on #{new_resource.name}")
    execute "Install module #{new_resource.name}" do
      command "modprobe #{new_resource.name}"
      user "root"
    end
    new_resource.updated_by_last_action(true)
	end
end


def load_current_resource
  @module = Chef::Resource::BobscodeModule.new(new_resource.name)
#  Chef::Log.info("Checking for module #{new_resource.name}")
  exists = shell_out("lsmod").stdout =~ /^#{new_resource.name}/
# try substituting dashes for underscores
	testname = new_resource.name.gsub("-", "_")
	exists ||= shell_out("lsmod").stdout =~ /^#{testname}/
# try substituting underscores for dashes 
	testname = new_resource.name.gsub("_", "-")
	exists ||= shell_out("lsmod").stdout =~ /^#{testname}/
  @module.exists(exists ? true : false)
end
