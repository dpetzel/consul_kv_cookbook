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
def whyrun_supported?
  true
end

use_inline_resources

action :create do
  unless @current_resource.current_value == new_resource.value
    ::Chef::Log.info('Creating Consul Key/Value '\
      "#{new_resource.path}:#{new_resource.value}")
    tries = 3
    begin
      http = Net::HTTP.new(new_resource.uri.hostname, new_resource.uri.port)
      path = new_resource.consul_acl.nil? ? new_resource.uri.path : new_resource.uri.path + '?token=' + new_resource.consul_acl
      request = Net::HTTP::Put.new(path)
      request.body = new_resource.value
      response = http.request(request)

      unless response.class == Net::HTTPOK
        fail "Failed Creating Consul K/V: #{response}"
      end
      new_resource.updated_by_last_action(response.body == 'true')
    rescue => exc
      tries -= 1
      if tries > 0
        retry
      else
        ::Chef::Log.error("Failed Creating Consul K/V: #{exc.message}")
      end
    end
  end
end

action :delete do
  if new_resource.exist?
    ::Chef::Log.info('Deleting Consul Key/Value '\
      "#{new_resource.path}:#{new_resource.value}")
    tries = 3
    begin
      path = new_resource.consul_acl.nil? ? new_resource.uri.path : new_resource.uri.path + '?token=' + new_resource.consul_acl
      request = Net::HTTP::Delete.new(path)
      response = @http.request(request)
      new_resource.updated_by_last_action(response.class == Net::HTTPOK)
    rescue => exc
      tries -= 1
      if tries > 0
        retry
      else
        ::Chef::Log.error("Failed Deleting Consul K/V: #{exc.message}")
      end
    end
  end
end

def load_current_resource
  validate!
  @http = Net::HTTP.new(new_resource.uri.hostname, new_resource.uri.port)
  @current_resource = Chef::Resource::ConsulKv.new(@new_resource.name)
  @current_resource.value('')
  @current_resource.value(new_resource.current_value)

  @current_resource
end

def validate!
  return if @action == :delete
  return unless new_resource.value.nil?

  fail ArgumentError,
       "#{new_resource.action} requires a value"
end
