source 'https://supermarket.getchef.com'

metadata

group :integration do
  cookbook 'consul_kv_test', path: './test/cookbooks/consul_kv_test'
  cookbook 'minitest-handler', '>= 1.3.2'

  # Work around https://github.com/sethvargo/chefspec/issues/507
  # https://github.com/opscode-cookbooks/windows/issues/131
  # The windows dependency comes from the consul cookbook
  cookbook 'windows', git: 'git://github.com/opscode-cookbooks/windows.git'
end
