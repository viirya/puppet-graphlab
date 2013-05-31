
# Puppet module for OpenMPI cluster and Graphlab

This puppet module helps setup OpenMPI cluster and install Graphlab.

## Dependency

Puppet module for Java 'viirya/java'.

## Usage

After installing this module in puppet master node, in site.pp, defining:

    node 'your cluster slave nodes' {
        include java
        include graphlab::cluster::slave
    }

    node 'your cluster master node' {
        include java
        include graphlab::cluster::master
    }

Download Graphlab release file and put it under files/.

Remember to modify necessary parameters in manifests/params.pp, such as 'version', 'master', 'slaves'. If you use Graphlab release graphlabapi_v2.1.4679.tar.gz, 'version' should be set to 'v2.1.4679'.

This module installs Graphlab under /opt/graphlab/graphlabapi. Configure and compile Graphlab on master node by:

    cd /opt/graphlab/graphlabapi
    ./configure
    cd release/
    make -j4

On master node, a file containing slave nodes of OpenMPI named 'nodes' is created under graphlab user 'hduser' home dir. A symlink 'graphlab' that points to /opt/graphlab is also created under the home dir.

On slave nodes, the dir 'graphlab' under the user's home dir is a mounted point for the Graphlab installation (/opt/graphlab) of master node through NFS. So all slave nodes can access mpi programs and data if you put them under /opt/graphlab of master node.

## Test

To test if the cluster and Graphlab are configured well, try on master node as the graphlab user 'hduser':

    # Download test data
    
    mkdir /opt/graphlab/smallnetflix
    cd /opt/graphlab/smallnetflix
    wget http://www.select.cs.cmu.edu/code/graphlab/datasets/smallnetflix_mm.train
    wget http://www.select.cs.cmu.edu/code/graphlab/datasets/smallnetflix_mm.validate

    # Go back home dir

    cd

    # Run Graphlab program

    mpiexec -n 14 -hostfile nodes ./graphlab/graphlabapi/release/toolkits/collaborative_filtering/als --matrix ./graphlab/smallnetflix --max_iter=3 --ncpus=1


