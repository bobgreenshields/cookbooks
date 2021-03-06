#
# Cookbook Name:: hosts
# Recipe:: default
#
# Copyright 2013, Robert Greenshields
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


log "version is #{node['lms']['lms_deb_version']}" do
	level :info
end

log "file is #{node['lms']['lms_deb_file']}" do
	level :info
end

log "url is #{node['lms']['lms_deb_url']}" do
	level :info
end

log "arch is #{node['lms']['arch']}" do
	level :info
end
