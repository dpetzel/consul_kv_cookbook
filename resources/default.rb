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
require 'net/http'
require 'base64'
require 'json'

actions :create, :delete
default_action :create

# The key name, aka path, at which to create the value
# /v1/kv/ is automatically prepended to this value
attribute :path, kind_of: String, name_attribute: true, required: true

# The value to set
attribute :value, kind_of: String, default: nil

# The Consul HTTP API endpoint.
attribute :consul_addr, kind_of: String, default: '127.0.0.1:8500'

# The Consul ACL token
attribute :consul_acl, kind_of: String, default: nil

# The full URI to the key
#
# @return [String]
def uri
  key_path = path
  key_path = path[1..-1] if path.start_with?('/')
  key_path = key_path + '?acl=' + consul_acl unless consul_acl.nil?
  URI("http://#{consul_addr}/v1/kv/#{key_path}")
end

# Does the given key exist at the path supplied?
#
# @return [Boolean]
def exist?
  res = Net::HTTP.get_response(uri)
  res.class == Net::HTTPOK
rescue
  false
end

# Return the decoded value of what is currently in the Key
#
# @return [String]
def current_value
  return '' unless exist?
  response = Net::HTTP.get_response(uri)
  raw_json = response.body
  parsed_json = JSON.parse(raw_json)
  # This returns and Array. We not currently supporting recursive values
  # so we only care about the first one
  key_data = parsed_json.first
  # The value is stored as the "Value" key in the key_data Hash
  return '' if key_data['Value'].nil?
  Base64.decode64(key_data['Value'])
end
