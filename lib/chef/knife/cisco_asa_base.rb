#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

require 'chef/knife'
require 'cisco'
require 'highline/import'

class Chef
  class Knife
    module CiscoAsaBase

      def self.included(includer)
        includer.class_eval do

          deps do
            require 'readline'
            require 'chef/json_compat'
          end

          unless defined? $default
            $default = Hash.new
          end

          option :cisco_asa_enable_password,
            :short => "-E PASSWORD",
            :long => "--cisco-asa-enable-password PASSWORD",
            :description => "Enable password for Cisco ASA"

          option :cisco_asa_hostname,
            :short => "-h HOSTNAME",
            :long => "--cisco-asa-hostname HOSTNAME",
            :description => "The hostname for Cisco ASA"

          option :cisco_asa_password,
            :short => "-p PASSWORD",
            :long => "--cisco-asa-password PASSWORD",
            :description => "The password for Cisco ASA"

          option :cisco_asa_username,
            :short => "-u USERNAME",
            :long => "--cisco-asa-username USERNAME",
            :description => "The username for Cisco ASA"
          $default[:cisco_asa_username] = ENV['USER']

          option :noop,
            :long => "--noop",
            :description => "Perform no modifying operations",
            :boolean => false
        end
      end

      def get_config(key)
        key = key.to_sym
        rval = config[key] || Chef::Config[:knife][key] || $default[key]
        Chef::Log.debug("value for config item #{key}: #{rval}")
        rval
      end

      def get_cisco_asa_config
        config[:cisco_asa_password] = ask("Cisco Password for #{get_config(:cisco_asa_username)}: ") { |q| q.echo = "*" } unless get_config(:cisco_asa_password)
        config[:cisco_asa_enable_password] = ask("Enable Password for #{get_config(:cisco_asa_hostname)}: ") { |q| q.echo = "*" } unless get_config(:cisco_asa_enable_password)
      end

      def run_config_commands(commands)
        asa = Cisco::Base.new(:host => get_config(:cisco_asa_hostname), :user => get_config(:cisco_asa_username), :password => get_config(:cisco_asa_password), :transport => :ssh)
        asa.enable(get_config(:cisco_asa_enable_password))
        asa.cmd("conf t")
        commands.each do |command|
          asa.cmd(command)
        end
        asa.cmd("end")
        asa.cmd("write mem")
        unless get_config(:noop)
          output = asa.run
          output.each do |line|
            Chef::Log.debug(line)
          end
        end
        output
      end

      def tcp_test_port(hostname,port)
        tcp_socket = TCPSocket.new(hostname, port)
        readable = IO.select([tcp_socket], nil, nil, 5)
        if readable
          Chef::Log.debug("sshd accepting connections on #{hostname}, banner is #{tcp_socket.gets}") if port == 22
          true
        else
          false
        end
        rescue Errno::ETIMEDOUT
          false
        rescue Errno::EPERM
          false
        rescue Errno::ECONNREFUSED
          sleep 2
          false
        rescue Errno::EHOSTUNREACH, Errno::ENETUNREACH
          sleep 2
          false
        ensure
          tcp_socket && tcp_socket.close
      end
      
    end
  end
end
