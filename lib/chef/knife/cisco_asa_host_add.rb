#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

module CiscoAsaKnifePlugin

  require 'chef/knife'

  class CiscoAsaHostAdd < BaseCiscoAsaCommand

    banner "knife cisco asa host add NAME IP (options)"
    category "cisco asa"

    get_common_options

    option :description, 
      :long => "--description DESCRIPTION",
      :description => "Description of host"

    option :groups, 
      :long => "--groups GROUP1[,GROUP2]",
      :description => "Groups for host"
    
    option :nat,
      :long => "--nat IP",
      :description => "NAT IP"

    option :nat_dns,
      :long => "--nat-dns",
      :description => "Enable NAT DNS translation",
      :boolean => false

    def run
      
      hostname = name_args.first

      if hostname.nil?
        ui.fatal "You need a host name!"
        show_usage
        exit 1
      end

      ip = name_args[1]

      if ip.nil?
        ui.fatal "You need an IP!"
        show_usage
        exit 1
      end

      args = name_args[2]
      if args.nil?
        args = ""
      end

      get_cisco_asa_config
      commands = []

      ui.info "Adding host to Cisco ASA:"
      ui.info "#{ui.color "ASA:", :cyan} #{get_config(:cisco_asa_host)}"
      ui.info "#{ui.color "Host:", :cyan} #{hostname}"
      ui.info "#{ui.color "IP:", :cyan} #{ip}"

      commands << "object network #{hostname}"
      commands << "  host #{ip}"

      if get_config(:description)
        ui.info "#{ui.color "Description:", :cyan} #{get_config(:description)}"
        commands << "  description #{get_config(:description)}"
      end

      if get_config(:nat)
        ui.info "#{ui.color "NAT IP:", :cyan} #{get_config(:nat)}"
        command = "  nat static #{get_config(:nat)}"
        if get_config(:nat_dns)
          ui.info "#{ui.color "NAT DNS:", :cyan} Enabled"
          command = command + " dns"
        end
        commands << command
      end

      if get_config(:groups)
        get_config(:groups).split(",").each do |group|
          ui.info "#{ui.color "Group:", :cyan} #{group}"
          commands << "object-group network #{group}"
          commands << "  network-object object #{hostname}"
        end
      end

      if get_config(:noop)
        ui.info "#{ui.color "Skipping host creation process because --noop specified.", :red}"
      else
        run_config_commands(commands)
      end
      
    end

  end
end
