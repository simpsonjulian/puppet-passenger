class apache::passenger { 
  
  file {
    "brightbox apt source":
      path => '/etc/apt/sources.list.d/brightbox.list',
      ensure => present,
      content => 'deb http://apt.brightbox.net hardy main',
      require => Exec["brightbox deb key"],
      notify => Exec["apt get update"];
    
  }
  exec {
    "brightbox deb key":
     command => "/usr/bin/wget -O /root/brightbox.asc \
     http://apt.brightbox.net/release.asc;/usr/bin/apt-key add /root/brightbox.asc",
     unless => "/usr/bin/apt-key list | grep -i brightbox";
  
  }
  
  package { 
     'libapache2-mod-passenger':
       ensure => installed,
       require => Exec["apt get update"];
    'fastthread': 
       require => Package["rubygems"],
       ensure => present,
       provider => gem;
    'rails': 
       require => Package["rubygems"],
       ensure => '2.3.4', 
       provider => gem;
  }
}
