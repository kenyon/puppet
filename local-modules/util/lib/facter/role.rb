# frozen_string_literal: true

# Puppet facter custom fact. Returns the role of a node.

Facter.add('role') do
  setcode do
    # Can't access trusted facts. :(
    case Facter.value(:networking)['hostname']
    when 'einstein'
      'workstation'
    when 'hydrogen'
      'homeserver'
    when 'puppet'
      'puppetserver'
    end
  end
end
