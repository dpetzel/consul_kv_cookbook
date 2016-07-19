# Consul Kv
[![Build Status](https://api.shippable.com/projects/545ee930c6f0803064f3db48/badge?branchName=master)](https://app.shippable.com/projects/545ee930c6f0803064f3db48/builds/latest)

This cookbook exposes the `consul_kv` LWRP which can be used to
create/update/delete Key/Value entries in an idempotent manner.

## Requirements
The cookbook has no direct dependencies, but it is assumed you are already
have a working [Consul](https://consul.io/) installation.

## Usage
Ensure you add `depends 'consul_kv'` to **your** cookbook's metadata.rb. With
that dependency in place you can then leverage the LWRP in your own cookbooks.

This cookbook does no't provide any recipes, it exists solely to deliver the
Key/Value LWRP.

Here are a few examples:

This example will create a new key at `my/key` with a value of `hello world`,
using the Consul HTTP available on the local machine running on the default
port of 8500

```
consul_kv 'test' do
  path 'my/key'
  value 'hello world'
  consul_addr '127.0.0.1:8500'
end
```

### Actions
The following actions are supported by the `consul_kv` LWRP:

* `:create` - Creates the key if it does not already exist. If the key already
  exists and is a different value, the existing value will be replaced by
  the requested value. This is the default action
* `:delete` - Deletes an existing key

### Attributes
The following attributes are supported by the LWRP:

* `path` The key path/name at which the value will be created/deleted
    * **type** - String
    * **required** - true
* `value` The value to be set in Key/Value store
    * **type** - String
    * **required** - Only for the `:create` action. This can be omitted for the
      `:delete` action
* `consul_addr` - The address to the Consul HTTP API.
    * **type** - String
    * **required** - false
    * **default** - 127.0.0.1:8500
* `token` - The ACL token to access to Consul HTTP API.
    * **type** - String
    * **required** - false



## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Testing

This cookbook currently uses [test-kitchen](https://github.com/opscode/test-kitchen)
along with [ChefSpec](https://docs.getchef.com/chefspec.html).

Test Kitchen: `kitchen test`

ChefSpec: `bundle exec rspec`

## Releasing
This cookbook uses an 'even number' release strategy. The version number in master
will always be an odd number indicating development, and an even number will
be used when an official build is released.

Come release time here is the checklist:

* Ensure the `metadata.rb` reflects the proper *even* numbered release
* Ensure there is a *dated* change log entry in `CHANGELOG.md`
* Commit all the changes
* Use stove to release (`bundle exec stove`)
* Bump the version in metadata.rb to the next *patch level* odd number

## Authors
- Author: David Petzel (<davidpetzel@gmail.com>)

