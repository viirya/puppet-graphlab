
# Puppet module for OpenMPI cluster and Graphlab

This puppet module helps setup OpenMPI cluster and install Graphlab.


## Usage

After installing this module in puppet master node, in site.pp, defining:

node 'your cluster slave nodes' {
    include graphlab::cluster::slave
}

node 'your cluster master node' {
    include graphlab::cluster::master
}

Download Graphlab release file and put it under files/.

Remember to modify necessary parameters in manifests/params.pp, such as 'version', 'master', 'slaves'. If you use Graphlab release graphlabapi_v2.1.4679.tar.gz, 'version' should be set to 'v2.1.4679'.


