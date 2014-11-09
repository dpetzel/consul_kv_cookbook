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

require_relative '../../spec_helper'

describe 'consul_kv_test::default' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  it 'creates the test1 kv' do
    expect(chef_run).to create_consul_kv('test1')
  end

  it 'creates the test2 kv' do
    expect(chef_run).to create_consul_kv('test2')
  end

  it 'creates the test3 kv' do
    expect(chef_run).to create_consul_kv('test3')
  end

  it 'deletes the test3 kv' do
    expect(chef_run).to delete_consul_kv('test3_delete')
  end

  it 'creates the test4 kv' do
    expect(chef_run).to create_consul_kv('test4')
  end

  it 'handles a delete for a key that does not exist' do
    expect(chef_run).to delete_consul_kv('test5')
  end
end
