#
# Cookbook Name:: hosts
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

if (node[:platform] == "ubuntu") and (node[:platform_version].to_f >= 10.04) then
  apt_package "xserver-xorg-video-nouveau" do
    action :purge
  end

  execute "nvidia-xconfig" do
    user "root"
    action :nothing
  end

  apt_package "nvidia-current" do
    action :install
    notifies :run, "execute[nvidia-xconfig]"
  end
end


