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
require File.expand_path('minitest_helper', File.dirname(__FILE__))

describe 'consul_kv::default' do
  include ConsulKv::TestHelper

  # rubocop:disable Style/Documentation, Style/ClassAndModuleChildren
  class Minitest::Test
    # I suspect there is probably a better way to do this, but I couldn't
    # find it. I originally had some logic here that would test that the API
    # was responding. Even with that, I was getting random failures with
    # data that was set, not getting returned, almost as if there is a delay
    # in the commit of the data even with a single node. The only way I could
    # avoid these errors was a one-time sleep.

    # rubocop:disable Style/ClassVars
    @@wait_for_consule = sleep(10)
  end

  before(:each) do
    @resource = Chef::Resource::ConsulKv.new('minitest')
    @resource.consul_addr('127.0.0.1:8500')
  end

  it 'creates a kv at the top level' do
    @resource.path('test4')
    assert(@resource.exist?)
    @resource.current_value.must_equal('test4')
  end

  it 'creates a kv in a nested level' do
    @resource.path('/test/2/here')
    assert(@resource.exist?)
  end

  it 'deletes a kv' do
    @resource.path('test/3/here')
    refute(@resource.exist?)
  end

  it 'handles deletion of a kv that doesnt exist' do
    @resource.path('test5')
    refute(@resource.exist?)
  end

  it 'reports when a key does not exist' do
    @resource.path('some/bogus/key/path')
    refute(@resource.exist?)
  end

end
