class site_tor {
  tag 'leap_service'

  $tor            = hiera('tor')
  $bandwidth_rate = $tor['bandwidth_rate']
  $tor_type       = $tor['type']
  $nickname       = $tor['nickname']
  $contact_email  = $tor['contacts']

  $address        = hiera('ip_address')

  class { 'tor::daemon': }
  tor::daemon::relay { $nickname:
    port             => 9001,
    address          => $address,
    contact_info     => $contact_email,
    bandwidth_rate   => $bandwidth_rate,
    my_family        => '$2A431444756B0E7228A7918C85A8DACFF7E3B050',
  }

  tor::daemon::directory { $::hostname: port => 80 }

  include site_shorewall::tor

  if ( $tor_type != 'exit' ) {
    include site_tor::disable_exit
  }

}
