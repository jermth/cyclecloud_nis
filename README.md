
Cyclecloud NIS
==============

This project sets up NIS on a CycleCloud Cluster

   
Pre-Requisites
--------------

This sample requires the following:

  1. CycleCloud must be installed and running.

     a. If this is not the case, see the CycleCloud QuickStart Guide for
        assistance.

  2. The CycleCloud CLI must be installed and configured for use.

  3. You must have access to log in to CycleCloud.

  4. You must have access to upload data and launch instances in your chosen
     Azure subscription

  5. You must have access to a configured CycleCloud "Locker" for Project Storage
     (Cluster-Init and Chef).
     
  6. Optional: To use the `cyclecloud project upload <locker>` command, you must
     have a Pogo configuration file set up with write-access to your locker.

     a. You may use your preferred tool to interact with your storage "Locker"
        instead.


Usage
=====

A. Configuring the Project
--------------------------

The first step is to configure the project for use with your storage locker:

  1. Open a terminal session with the CycleCloud CLI enabled.

  2. Switch to the CycleCloud-NIS project directory, that's the top level directory of this git repo, with the `project.ini` file in it.

  3. Run ``cyclecloud project default_locker my_locker`` (assuming the locker is named "my_locker").
     The locker name will generally be the same as the cloud provider you created when configuring
     CycleCloud. The expected output looks like this:::

        $ cyclecloud project default_locker my_locker
        Name: cyclecloud_nis
        Version: 1.0.0
        Default Locker: my_locker

       
B. Deploying the Project
------------------------

To upload the project (including any local changes) to your target locker, run the
`cyclecloud project upload` command from the project directory.  The expected output looks like
this:::

    $ cyclecloud project upload
    Sync completed!

*IMPORTANT*

For the upload to succeed, you must have a valid Pogo configuration for your target Locker.


C. Using this project
---------------------
1. This project only works with a single NIS server. Additional NIS slaves are not supported.

2. The project is designed so that the NIS server provides YP services for nodes in a single cluster.

3. Assign master or headnode of the cluster as the NIS server. Do this by adding the `cyclecloud_nis:default` and `cyclecloud_nis:server` specs to the master node of the cluster. You can use the _*Additional Cluster-Init"*_ feature in the cluster creation or edit UI.

4. All other cluster nodes, including the compute or execute nodes of the cluster are are assigned as NIS clients. Do this by adding the `cyclecloud_nis:default` and `cyclecloud_nis:client` specs to all other nodes of the cluster. You can use the _*Additional Cluster-Init"*_ feature in the cluster creation or edit UI.

5. The NIS server provides yp services for the passwd, group, and hosts tables.

6. To add a new user (or hosts), login to the NIS server, add the new user locally, and run the `make` command in the /var/yp directory. This will update the YP tables. E.g:
'''
    $ useradd -m -b /shared/home lara
    $ cd /var/yp && make
'''
7. Verify that the new user is added by query with ypcat:
'''
    $ ypcat passwd
''' 




# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

