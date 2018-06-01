# == Define: dhcp::dhcp_subclass
#
define dhcp::dhcp_subclass (
  String $depends,
  Variant[Array[String], String] $parameters,
) {
  include ::dhcp::params

  if ! defined(Dhcp::Dhcp_class[$depends]) {
    fail("Class ${depends} must be declared")
  }

  $dhcp_dir = $dhcp::params::dhcp_dir

  concat::fragment { "dhcp_subclass_${name}":
    target  => "${dhcp_dir}/dhcpd.hosts",
    content => template('dhcp/dhcpd.subclass.erb'),
    order   => '50',
  }
}
