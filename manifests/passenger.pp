class apache::passenger { 
  
  file {
    "brightbox apt source":
      path => '/etc/apt/sources.list.d/brightbox.list',
      ensure => present,
      content => 'deb http://apt.brightbox.net hardy main',
      require => Exec["brightbox deb key"];
    
  }
  exec {
		"brightbox deb key":
		  command => "/usr/bin/wget -O /root/brightbox.asc \
		  http://apt.brightbox.net/release.asc;/usr/bin/apt-key add /root/brightbox.asc",
		  unless => "/usr/bin/apt-key list | grep -i brightbox";
	
	}
  
  exec { 
		"apt_get_update":
		  command => "/usr/bin/apt-get update",
		  require => File["brightbox apt source"],
  	  subscribe => File["brightbox apt source"],
  	  refreshonly => true;
   	}
  
  package { 
		"libapache2-mod-passenger":
		  ensure => installed,
		  require => Exec["apt_get_update"];
    'rubygems': ensure => present;
    "ruby1.8-dev": ensure => present;
    "build-essential": ensure => present;
  }
}
node socks { include apache::passenger }