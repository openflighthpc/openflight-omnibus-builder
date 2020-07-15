# Cluster VPN
Your Flight Compute cluster is configured with a Virtual Private Network (VPN) - allowing you to connect your workstation to the cluster network. The cluster VPN provides your machine with an IP address that is part of the environment's network, allowing direct communication with compute nodes for high-performance graphical application access and data transfer. All communications exchanged over a VPN are automatically encrypted using a certificate unique to your cluster.

The Alces Flight Compute VPN uses [OpenVPN](https://openvpn.net/) - so you may wish to use a client that is capable of connecting using OpenVPN configurations.

## Available VPN clients
There are many VPN clients available which support OpenVPN configurations - some popular clients for each platform include;

### MacOS
- [TunnelBlick](https://tunnelblick.net/)

### Linux
- NetworkManager includes support for OpenVPN configurations

### Windows
- [OpenVPN](https://openvpn.net/index.php/open-source/downloads.html)

## Obtaining VPN configuration
VPN configuration packs for different VPN clients are available through the Alces Flight web page. You can find your Alces Flight web page access information by:

> - Viewing the `Outputs` tab of your AWS CloudFormation Flight Compute stack - which displays the `http` access address
> 
> - Logging on to your Flight Compute environment and running the command `alces about www` which displays access information

Once you have navigated to your Alces Flight Compute web page - you can click on the **VPN** button, which will allow you to visit the VPN configuration page. From the VPN configuration page, you will be offered a range of VPN configuration file packs for different VPN client types as well as brief instructions on how to connect to the VPN using your downloaded configuration packs:

## Connecting to VPN
Instructions for connecting to VPN from Windows, Mac & Linux platforms can be found at  beneath the  &  sections of the Alces Flight VPN web page.

