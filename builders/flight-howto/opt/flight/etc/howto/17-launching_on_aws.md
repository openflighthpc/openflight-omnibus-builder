# Launching on AWS
Alces Flight Compute Solo can be launched on the Amazon Web Services (AWS) public cloud platform to give you instant access to your own, private HPC cluster from anywhere in the world. You can choose what resources your cluster will start with (e.g. number of nodes, amount of memory, etc.), and for how long the cluster will run.

## Prerequisites
There are some things that you need to get ready before you can launch your own cluster on AWS. They are:

> - **Check client prerequisites** to make sure you have the software you need - see 
> 
>   :ref:`whatisit`
> 
>   
> 
>   "System Message: ERROR/3 (17-launching_on_aws.rst:, line 14)"
>   Unknown interpreted text role "ref".
> 
> - **Get yourself an AWS account**; this might be your personal account, or you may have a sub-account as part of your institution or company
> 
> - **Create an SSH keypair** for yourself in the region you want to run in. [Follow this guide](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) if you've not done this before.

More details on [AWS Identity and Access Management (IAM) are available here](https://aws.amazon.com/iam/).

## Creating your Cluster
### Method of Launching
The simplest method of launching a cluster is by using AWS Cloudformation (CFN) - clusters launch using a CFN template which asks the user a number of simple questions in order to configure their cluster environment. This method is documented on this page, and is the fastest way to launch your own, personal HPC cluster environment.

Advanced users may also wish to launch a cluster one instance at a time, or deploy a single login node to be used interactively. Follow this guide for information on how to manually configure a cluster by launching individual instances - 

:ref:`manual_launch`

.

"System Message: ERROR/3 (17-launching_on_aws.rst:, line 35)"
Unknown interpreted text role "ref".

Users can also use one of the example CloudFormation templates as the basis of their own cluster deployments. This allows more customisation of your cluster, including choosing how many nodes can be launched, configuring different types of EBS backing storage and choosing different availability zones for your compute nodes. For more information, see - 

:ref:`template_launch`

.

"System Message: ERROR/3 (17-launching_on_aws.rst:, line 37)"
Unknown interpreted text role "ref".

### How much will it cost?
The cost for running your cluster will depend on a number of different factors including the resources you consume and the software you subscribe to. Charges typically fall into the following categories:

> - [EC2](https://aws.amazon.com/ec2/) charges for running instances (your login and compute nodes)
> 
> - [EBS](https://aws.amazon.com/ebs/) charges for shared cluster filesystem capacity
> 
> - [S3](https://aws.amazon.com/s3/) charges for storing data as objects
> 
> - [Data-egress charges](https://aws.amazon.com/blogs/publicsector/aws-offers-data-egress-discount-to-researchers/) for network traffic out of AWS
> 
> - [Miscellaneous other charges](https://aws.amazon.com/pricing/services/) (e.g. IP address allocation, DNS entry updates, etc.)
> 
> - Any costs for running the version of Alces Flight that you subscribe to

Most charges are made per unit (e.g. per compute node instance, or per GB of storage space) and per hour, often with price breaks for using more of a particular resource at once. A full breakdown of pricing is beyond the scope of this document, but there are several tools designed to help you estimate the expected charges; e.g.

> - [AWS Simple Monthly Calculator](https://calculator.s3.amazonaws.com/index.html)
> 
> - [AWS TCO Calculator](https://awstcocalculator.com/)

### Launching Alces Flight Compute on AWS
"System Message: WARNING/2 (17-launching_on_aws.rst:, line 58)"
Title underline too short.

{language=python}
```
Launching Alces Flight Compute on AWS
-----------------------------------
```

Sign-in to your AWS account, and navigate to the AWS Console. Search for **Cloud Formation** in your AWS console and click to visit the page:

In the CloudFormation console, ensure that your AWS region is set to where you'd like the cluster to be launched - the region name is shown on the right of the menu bar at the top of the page. Click on the blue **Create Stack** button on the top-left hand side of the page to launch a new cluster:

In the AWS console window, choose the option to **Specify an Amazon S3 template URL** and enter the following URL into the text box:

[https://s3-eu-west-1.amazonaws.com/openflighthpc/templates/solo-cluster.yaml](https://s3-eu-west-1.amazonaws.com/openflighthpc/templates/solo-cluster.yaml)

Click on the **Next** button to begin launching your cluster.

### How to answer CloudFormation questions
When you choose to start a Flight Compute cluster using AWS CFN, you will be prompted to answer a number of questions about what you want the environment to look like. Flight will automatically launch your desired configuration based on the answers you give. The questions you'll be asked are the following:

> - **Stack name**; this is the name that you want to call your cluster. It's fine to enter **"cluster"** here if this is your first time, but entering something descriptive will help you keep track of multiple clusters if you launch more. Naming your cluster after colours (red, blue, orange), your favourite singer (clapton, toriamos, bieber) or Greek legends (apollo, thor, aphrodite) keeps things more interesting. Avoid using spaces and punctuation, or names longer than 16 characters.

**Access and security**

> - **Cluster administrator username**; enter the username you want to use to connect to the cluster. Flight will automatically create this user on the cluster, and add your public SSH key to the user.
> 
> - **Cluster administrator keypair**; choose an existing AWS keypair to launch your Flight cluster with. If there are no keypairs in the list, check that you've already generated a keypair in the region you're launching in. You must have the private key available for the chosen keypair in order to login to your cluster.
> 
> - **Access network address**; enter a network range that is permitted to access your cluster. This will usually be the IP address of your system on the Internet; ask your system administrator for this value, or [use a web search](https://www.google.com/search?q=whats+my+ip+address&ie=utf-8&oe=utf-8&gws_rd=cr&ei=tVIvV5_dKsHagAath7OYCw) to find out. If you want to be able to access your cluster from anywhere on the Internet, enter "0.0.0.0/0" in this box.

When all the questions are answered, click the **Next** button to proceed. Enter any tags you wish to use to identify instances in your environment on the next page, then click the **Next** button again. On the review page, read through the answers you've provided and correct any mistakes - click on the *Capabilities* check-box to authorize creations of an IAM role to report cluster performance back to AWS, and click on the **Create** button.

Your personal compute cluster will then be created. While on-demand instances typically start within in few minutes, SPOT based instances may take longer to start, or may be queued if the SPOT price you entered is less than the current price.

### On-demand vs SPOT instances
The AWS EC2 service supports a number of different charging models for launching instances. The quick-start AWS CloudFormation template allows users to choose between two different models:

> - On-demand instances; instances are launched immediately at a fixed hourly price. Once launched, your instance will not normally be terminated unless you choose to stop it.
> 
> - [SPOT instances](https://aws.amazon.com/ec2/spot/); instances are requested with a bid-price entered by the end-user which represents the maximum amount they want to pay for them per hour. If public demand for this instance type allows, instances will be launched at the current SPOT price, which is typically much lower than the equivalent on-demand price. As demand increases for the instance type, so does the cost per hour charged to the users. AWS will automatically stop any instances (or delay starting new ones) if the current SPOT price is higher than the maximum amount users want to pay for them.

SPOT instances are a good way to pay a lower cost for cloud computing for non-urgent workloads. If SPOT compute node instances are terminated in your cluster, any running jobs will be lost - the nodes will also be automatically removed from the queue system to ensure no new jobs attempt to start on them. Once the SPOT price becomes low enough for your instances to start again, your compute nodes will automatically restart and rejoin the cluster.

The AWS CloudFormation template provided for Alces Flight Compute will not launch a login node instance on the SPOT market - **login nodes are always launched as on-demand instances**, and are immune from fluctuating costs in the SPOT market.

### Using an auto-scaling cluster
An auto-scaling cluster automatically reports the status of the job scheduler queue to AWS to allow idle compute nodes to be shut-down, and new nodes to be started when jobs are queuing. Auto-scaling is a good way to manage the size of your ephemeral cluster automatically, and is useful if you want to run a number of unattended jobs, and minimise costs after the jobs have finished by terminating unused resources.

Your Alces Flight compute cluster will never scale larger than the maximum number of instances entered at launch time. The cluster will automatically scale down to a single compute node when idle, or be reduced to zero nodes if you are using SPOT based compute nodes, and the price climbs higher than your configured maximum.

If you are running jobs manually (i.e. not through the job-scheduler), you may wish to disable autoscaling to prevent nodes not running scheduled jobs from being shutdown. This can be done by entering `0` (zero) in the **ComputeSpotPrice** when launching your Flight Compute cluster via AWS CloudFormation, or using the command `alces configure autoscaling disable` command when logged in to the cluster login node.

## Accessing your cluster
Once your cluster has been launched, the login node will be accessible via SSH from the IP address range you entered in the **NetworkCIDR**. If you entered `0.0.0.0/0` as the **NetworkCIDR**, your login node will be accessible from any IP address on the Internet. Your login node's public IP address is reported by the AWS CloudFormation template, along with the username you must use to login with your keypair.

### Linux/Mac
To access the cluster login node from a Linux or Mac client, use the following command:

> - `ssh -i mypublickey.pem myusername@52.50.141.144`

### Windows
If you are accessing from a Windows client using the Putty utility, the private key associated with the account will need to be converted to ppk format from pem to be compatible with Putty. This can be done as follows:

- Open PuTTYgen (this will already be installed on your system if Putty was installed using .msi and not launched from the .exe - if you do not think you have this, download putty-installer from here [http://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html](http://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html))

- Select 

- Locate  file and click 

- Click 

- Answer  to saving without a passphrase

- Input the name for the newly generated ppk to be saved as

To load the key in Putty, select , click  and select the ppk that was generated from the above steps.

Next, enter the username and IP address of the cluster login node in the "Host Name" box provided (in the  section):

The first time you connect to your cluster, you will be prompted to accept a new server SSH hostkey. This happens because you've never logged in to your cluster before - it should only happen the first time you login; click **OK** to accept the warning. Once connected to the cluster, you should be logged in to the cluster login node as your user.

## Accessing your cluster web interface
Your cloud service provider will report a web-access URL that points to the management interface for your cluster once it is launched. This interface collects together all support and documentation services under a single page, helping users to access their cluster and request assistance if required.

## Terminating the cluster
Your cluster login node will continue running until you terminate it via the [AWS web console](https://aws.amazon.com/console/). If you are running an auto-scaling cluster, compute nodes will automatically be added and taken away up to the limits you specified depending on the number of jobs running and queued in the job-scheduler. When you have finished running your workloads, navigate to the [CloudFormation console](https://console.aws.amazon.com/cloudformation/), select the name of your cluster from the list of running stacks, and click **Delete stack** from the actions menu.

Over the next few minutes, your cluster login and compute nodes will be terminated. Any data held on EBS will be erased, with storage volumes being wiped and returned to the AWS pool. **Ensure that you have downloaded data that you want to keep to your client machine, or stored in safely in an object storage service before terminating your cluster.**

See - 

:ref:`data_basics`

 and 

:ref:`alces-sync`

 for more information on storing your data prior to terminating your cluster.

"System Message: ERROR/3 (17-launching_on_aws.rst:, line 269)"
Unknown interpreted text role "ref".

"System Message: ERROR/3 (17-launching_on_aws.rst:, line 269)"
Unknown interpreted text role "ref".

