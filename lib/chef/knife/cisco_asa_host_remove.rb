#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

module CiscoAsaKnifePlugin

  require 'chef/knife'

  class CiscoAsaHostRemove < BaseCiscoAsaCommand

    banner "knife cisco asa host remove NAME (options)"
    category "cisco asa"

    get_common_options

    option :groups, 
      :long => "--groups GROUP[,GROUP2]",
      :description => "Groups for host"

    option :nat,
      :long => "--nat IP",
      :description => "NAT IP"
    
    def run
      
      hostname = name_args.first.upcase

      if hostname.nil?
        ui.fatal "You need a host name!"
        show_usage
        exit 1
      end

      args = name_args[1]
      if args.nil?
        args = ""
      end

      get_cisco_asa_config
      commands = []

      ui.info "Removing host from Cisco ASA:"
      ui.info "#{ui.color "ASA:", :cyan} #{get_config(:cisco_asa_host)}"
      ui.info "#{ui.color "Host:", :cyan} #{hostname}"
      ui.info "#{ui.color "NAT IP:", :cyan} #{natip}"

      commands << "object network #{hostname}"
      commands << "  no nat (inside,outside) static #{natip} dns"

      if get_config(:groups)
        get_config(:groups).split(",").each do |group|
          ui.info "#{ui.color "Group:", :cyan} #{group}"
          commands << "object-group network #{group}"
          commands << "  no network-object object #{hostname}"
        end
      end

      commands << "no object network #{hostname}"

      if get_config(:noop)
        ui.info "#{ui.color "Skipping host removal process because --noop specified.", :red}"
      else
        run_config_commands(commands)
      end
      
    end

  end
end
