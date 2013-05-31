# /etc/puppet/modules/graphlab/manafests/init.pp

class graphlab::params {

	$version = $::hostname ? {
		default			=> "v2.1.4679",
	}

 	$graphlab_user = $::hostname ? {
		default			=> "hduser",
	}
 
 	$graphlab_group = $::hostname ? {
		default			=> "graphlab",
	}
        
	$master = $::hostname ? {
		default			=> "server1.novalocal",
	}
 
        
	$slaves = $::hostname ? {
		default			=> ["server2.novalocal", "server3.novalocal"] 
	}

	$export_base_path = $::hostname ? {
                default                 => "/opt",
        }
 
	$graphlab_base_path = $::hostname ? {
		default			=> "${export_base_path}/graphlab",
	}

        $nfs_server = $operatingsystem ? {
            ubuntu => nfs-kernel-server,
        }
        
        $nfs_client = $operatingsystem ? {
            ubuntu => nfs-common,
        } 

        $openmpi_lib = $operatingsystem ? {
            ubuntu => libopenmpi-dev,
        } 

        $openmpi_bin = $operatingsystem ? {
            ubuntu => openmpi-bin,
        } 

        $openmpi_doc = $operatingsystem ? {
            ubuntu => openmpi-doc,
        } 

        $tools = $operatingsystem ? {
            ubuntu => [ "make", "gcc", "g++", "zlib1g-dev", "libevent-pthreads-2.0-5" ],
        } 

        $graphlab_user_path = $::hostname ? {
		default			=> "/home/${graphlab_user}",
	}             

}
