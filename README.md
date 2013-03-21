# knife-cisco_asa

A knife plugin for managing Cisco ASA devices.

[![Gem Version](https://badge.fury.io/rb/knife-cisco_asa.png)](http://badge.fury.io/rb/knife-cisco_asa)
&nbsp;
[![Code Climate](https://codeclimate.com/github/bflad/knife-cisco_asa.png)](https://codeclimate.com/github/bflad/knife-cisco_asa)

## Installation

Uses [cisco rubygem](https://github.com/jtimberman/ruby-cisco) for the backend.

* `gem install knife-cisco_asa` (if using omnibus install, `/opt/chef/embedded/bin/gem install knife-cisco_asa`)
* or... copy `lib/chef/knife/*` files to `~/.chef/plugins/knife`
* or... copy `lib/chef/knife/*` files to `path/to/cheforg/.chef/plugins/knife`

## Usage

### Common parameters

Configuration in knife.rb:
* `knife[:cisco_asa_enable_password] = "ENABLE_PASSWORD"` - Enable password for Cisco ASA
* `knife[:cisco_asa_hostname] = "HOSTNAME"` - Cisco ASA hostname
* `knife[:cisco_asa_password] = "PASSWORD"` - Cisco ASA user password
* `knife[:cisco_asa_usernamename] = "USERNAME"` - Cisco ASA username

Otherwise, from the command line:
* `--cisco-asa-enable-password ENABLE_PASSWORD` - Enable password for Cisco ASA
* `--cisco-asa-hostname HOSTNAME` - Cisco ASA hostname
* `--cisco-asa-password PASSWORD` - Cisco ASA user password
* `--cisco-asa-username USERNAME` - Cisco ASA username
* `--noop` - Perform no modifying operations

Any missing user or enable password will be prompted at runtime.

### `knife cicso asa host add NAME IP`

Adds a host to the device.

* `--description DESCRIPTION` - optionally set a description for the host
* `--groups GROUP1[,GROUP2]` - optionally add host to object groups
* `--nat IP` - optionally setup static NAT IP
* `--nat-dns` - optionally enable DNS translation for NAT

### `knife cicso asa host remove NAME`

Removes a host from the device.

* `--groups GROUP1[,GROUP2]` - required to remove hosts in groups
* `--nat IP` - required to remove hosts with static NAT IP

## Contributing

Please use standard Github issues and pull requests.

## License and Author
      
Author:: Brian Flad (<bflad417@gmail.com>)

Copyright:: 2013

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
