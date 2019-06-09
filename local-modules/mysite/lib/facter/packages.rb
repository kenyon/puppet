# Puppet Facter custom fact. Return a list of packages installed on
# the system as a hash, mapping the package name to the version.

# By Kenyon Ralph

Facter.add(:packages) do
  setcode do
    packages = {}
    case Facter.value(:os)['family']
    when 'Debian'
      pkglist = Facter::Core::Execution.execute("dpkg-query --show --showformat='${Package} ${Version}\n'")
    when 'RedHat'
      pkglist = Facter::Core::Execution.execute("rpm --query --all --queryformat='%{name} %{version}\n'")
    end
    pkglist.each_line do |line|
      packages[line.split()[0]] = line.split()[1]
    end

    packages
  end
end
