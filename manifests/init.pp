# /etc/puppet/modules/graphlab/manafests/init.pp

class graphlab {

	require graphlab::params
	
	group { "${graphlab::params::graphlab_group}":
		ensure => present,
		gid => "800"
	}

	user { "${graphlab::params::graphlab_user}":
		ensure => present,
		comment => "Graphlab",
		password => "!!",
		uid => "800",
		gid => "800",
		shell => "/bin/bash",
		home => "${graphlab::params::graphlab_user_path}",
		require => Group["graphlab"],
	}
	
	file { "${graphlab::params::graphlab_user_path}/.bashrc":
		ensure => present,
		owner => "${graphlab::params::graphlab_user}",
		group => "${graphlab::params::graphlab_group}",
		alias => "${graphlab::params::graphlab_user}-bashrc",
		content => template("graphlab/home/bashrc.erb"),
		require => User["${graphlab::params::graphlab_user}"]
	}
    	
	file { "${graphlab::params::graphlab_user_path}":
		ensure => "directory",
		owner => "${graphlab::params::graphlab_user}",
		group => "${graphlab::params::graphlab_group}",
		alias => "${graphlab::params::graphlab_user}-home",
		require => [ User["${graphlab::params::graphlab_user}"], Group["graphlab"] ]
	}

	file { "${graphlab::params::graphlab_base_path}":
		ensure => "directory",
		owner => "${graphlab::params::graphlab_user}",
		group => "${graphlab::params::graphlab_group}",
		alias => "${graphlab::params::graphlab_user}-base",
		require => [ User["${graphlab::params::graphlab_user}"], Group["graphlab"] ]
	}
 
	file { "${graphlab::params::graphlab_base_path}/graphlab_${graphlab::params::version}.tar.gz":
		mode => 0644,
		owner => "${graphlab::params::graphlab_user}",
		group => "${graphlab::params::graphlab_group}",
		source => "puppet:///modules/graphlab/graphlabapi_${graphlab::params::version}.tar.gz",
		alias => "graphlab-source-tgz",
		before => Exec["untar-graphlab"],
		require => File["${graphlab::params::graphlab_base_path}"]
	}
	
	exec { "untar graphlab_${graphlab::params::version}.tar.gz":
		command => "tar xfvz graphlab_${graphlab::params::version}.tar.gz",
		cwd => "${graphlab::params::graphlab_base_path}",
		creates => "${graphlab::params::graphlab_base_path}/graphlabapi",
		alias => "untar-graphlab",
		refreshonly => true,
		subscribe => File["graphlab-source-tgz"],
		user => "${graphlab::params::graphlab_user}",
		before => [ File["graphlab-app-dir"]],
                path    => ["/bin", "/usr/bin", "/usr/sbin"],
	}

	file { "${graphlab::params::graphlab_base_path}/graphlabapi":
		ensure => "directory",
		mode => 0644,
		owner => "${graphlab::params::graphlab_user}",
		group => "${graphlab::params::graphlab_group}",
		alias => "graphlab-app-dir",
                require => Exec["untar-graphlab"],
		before => [ File["graphlab-nodes"]]
	}

        file { "${graphlab::params::graphlab_user_path}/nodes":
            owner => "${graphlab::params::graphlab_user}",
            group => "${graphlab::params::graphlab_group}",
            mode => "644",
            alias => "graphlab-nodes",
            content => template("graphlab/conf/nodes.erb"),
            require => File["${graphlab::params::graphlab_user_path}"]
        }

        package { "${graphlab::params::openmpi_lib}":
            ensure  => installed,
        }
     
        package { "${graphlab::params::openmpi_bin}":
            ensure  => installed,
        }
     
        package { "${graphlab::params::openmpi_doc}":
            ensure  => installed,
        }

        package { $graphlab::params::tools:
            ensure => installed,
        }
        
	file { "${graphlab::params::graphlab_user_path}/.ssh/":
		owner => "${graphlab::params::graphlab_user}",
		group => "${graphlab::params::graphlab_group}",
		mode => "700",
		ensure => "directory",
		alias => "${graphlab::params::graphlab_user}-ssh-dir",
	}
	
	file { "${graphlab::params::graphlab_user_path}/.ssh/id_rsa.pub":
		ensure => present,
		owner => "${graphlab::params::graphlab_user}",
		group => "${graphlab::params::graphlab_group}",
		mode => "644",
		source => "puppet:///modules/graphlab/ssh/id_rsa.pub",
		require => File["${graphlab::params::graphlab_user}-ssh-dir"],
	}
	
	file { "${graphlab::params::graphlab_user_path}/.ssh/id_rsa":
		ensure => present,
		owner => "${graphlab::params::graphlab_user}",
		group => "${graphlab::params::graphlab_group}",
		mode => "600",
		source => "puppet:///modules/graphlab/ssh/id_rsa",
		require => File["${graphlab::params::graphlab_user}-ssh-dir"],
	}
 
	file { "${graphlab::params::graphlab_user_path}/.ssh/config":
		ensure => present,
		owner => "${graphlab::params::graphlab_user}",
		group => "${graphlab::params::graphlab_group}",
		mode => "600",
		source => "puppet:///modules/graphlab/ssh/config",
		require => File["${graphlab::params::graphlab_user}-ssh-dir"],
	}
    
	file { "${graphlab::params::graphlab_user_path}/.ssh/authorized_keys":
		ensure => present,
		owner => "${graphlab::params::graphlab_user}",
		group => "${graphlab::params::graphlab_group}",
		mode => "644",
		source => "puppet:///modules/graphlab/ssh/id_rsa.pub",
		require => File["${graphlab::params::graphlab_user}-ssh-dir"],
	}	
}
