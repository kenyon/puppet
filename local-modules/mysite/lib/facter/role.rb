# Puppet facter custom fact. Returns the role of a node.

Facter.add("role") do
  setcode do
    # Can't access trusted facts. :(
    case Facter.value(:networking)["hostname"]
    when "puppet"
      "puppetserver"
    end
  end
end
