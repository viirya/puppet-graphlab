# /etc/puppet/modules/graphlab/manifests/master.pp

class graphlab::cluster {
	# do nothing, magic lookup helper
}

class graphlab::cluster::master {

    require graphlab::params
    require graphlab

    package { "${graphlab::params::nfs_server}":
        ensure  => installed,
        alias   => "nfs_server_package",
    }

    file {'nfs_export':
        path    => '/etc/exports',
        ensure  => present,
        mode    => 0640,
        owner => "root",
        group => "root",
        content => template("graphlab/conf/exports.erb"),
        notify  => Service["nfs-kernel-server"],
        require => Package["nfs_server_package"],
    }

    service { "nfs-kernel-server":
        ensure  => "running",
        enable  => "true",
        require => Package["nfs_server_package"],
    }

    file { "${graphlab::params::graphlab_user_path}/graphlab":
        force => true,
        ensure => "${graphlab::params::graphlab_base_path}",   
        alias => "graphlab-symlink",
        owner => "${graphlab::params::graphlab_user}",
        group => "${graphlab::params::graphlab_group}",
    }

}

class graphlab::cluster::slave {

    require graphlab::params
    require graphlab

    package { "${graphlab::params::nfs_client}":
        ensure  => installed,
        alias   => "nfs_client_package",
    }

    file { "${graphlab::params::graphlab_user_path}/graphlab":
        ensure => "directory",
        owner => "${graphlab::params::graphlab_user}",
        group => "${graphlab::params::graphlab_group}",
        alias => "mount_point",
    }

    mount { "${graphlab::params::graphlab_user_path}/graphlab": 
        device  => "${graphlab::params::master}:/graphlab", 
        fstype  => "nfs4", 
        ensure  => "mounted", 
        options => "_netdev,auto",
	require => [ Package["nfs_client_package"], File["mount_point"] ],
    } 

}

