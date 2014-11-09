#
# Cookbook Name:: consul_kv
# Recipe:: default
#
# Copyright 2014 David Petzel
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

node.default['consul']['serve_ui'] = true
include_recipe 'consul'
include_recipe 'consul::ui'

consul_kv 'test1' do
  path 'test/test1'
  value 'test1'
  consul_addr '127.0.0.1:8500'
end

consul_kv 'test2' do
  # You don't really want to put the leading slash, but the lwrp
  # should do the right thing (drop it) if you did
  path '/test/2/here'
  value 'test2'
  consul_addr '127.0.0.1:8500'
end
consul_kv 'test3' do
  path 'test/3/here'
  value 'test2'
  consul_addr '127.0.0.1:8500'
end
consul_kv 'test3_delete' do
  action :delete
  path '/test/3/here'
  consul_addr '127.0.0.1:8500'
end
consul_kv 'test4' do
  path 'test4'
  value 'test4'
  consul_addr '127.0.0.1:8500'
end

# Deleting a key that doesn't exist
consul_kv 'test5' do
  action :delete
  path 'test5'
  consul_addr '127.0.0.1:8500'
end
