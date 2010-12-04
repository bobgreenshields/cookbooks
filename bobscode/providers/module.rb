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
	Chef::Log::info("install: module.exists is #{@module.exists}")
  Chef::Log.info("install: new_resource.name is #{new_resource.name}")
	unless @module.exists
    execute "Install module #{new_resource.name}" do
      command "modprobe #{new_resource.name}"
    end
    new_resource.updated_by_last_action(true)
  end
end


def load_current_resource
#  @smbuser = Chef::Resource::SambaUser.new(new_resource.name)
  @module = Chef::Resource::BobscodeModule.new(new_resource.name)

  Chef::Log.debug("Checking for module #{new_resource.name}")
#  u = shell_out("pdbedit -Lv -u #{new_resource.name}")
  u = shell_out("modinfo #{new_resource.name}")
  info = u.stdout.split(':')
  Chef::Log.info("info[0] is #{info[0]}")
#  Chef::Log.info("info[1] is #{info[1]}")
#  Chef::Log.info("info[2] is #{info[2]}")
#  Chef::Log.info("info[3] is #{info[3]}")
#  Chef::Log.info("info[4] is #{info[4]}")
  exists = !(info[0] == 'ERROR')
  @module.exists(exists)
end
