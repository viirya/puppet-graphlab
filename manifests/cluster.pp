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

}

class graphlab::cluster::slave {

    require graphlab::params
    require graphlab

    package { "${graphlab::params::nfs_client}":
        ensure  => installed,
        alias   => "nfs_client_package",
    }

    mount { "${graphlab::params::graphlab_user_path}/graphlab": 
        device  => "${graphlab::params::master}:/graphlab", 
        fstype  => "nfs4", 
        ensure  => "mounted", 
        options => "_netdev,auto",
	require => Package["nfs_client_package"],
    } 

}

