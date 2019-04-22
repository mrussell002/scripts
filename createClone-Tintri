Param(
  [string] $tintriserver,
  [string] $tsusername,
  [string] $tspassword,
  [string] $vmname,
  [string] $clonebasename,
  [string] $vmbaseFix,
  [string] $clonenum,
  [string] $desthost,
  [string] $destClust,
  [string] $destdatastore,
  [string] $snapdescription
)

##########################################################################################
# entries for TINTRI-01
# ONLY USE ONE OF THESE
#$tintriserver = '<name-of-tintri-server-01>'

# entries for TINTRI-02
# ONLY USE ONE OF THESE
$tintriserver = '<name-of-tintri-server-02'

# tintri username and password
$tsusername = 'admin'
$tspassword = '<tintri-password>'
##########################################################################################
# the name of the vm or template that you want to clone
$vmname = '<vm-name>'

# the snapshot to base the tintri clones off of
$snapdescription = '<vm-name-Base>'

# base name of the new clones, this will show up in vcenter
$clonebasename = '<new-clone-start-name>'

# NOT USED IN THIS SCRIPT
#$clonenum = '1'

# loop counter and used to create the vm name - set to your beginning and ending value
$i = 11
$e = 15
##########################################################################################
# the esxi host where the vms will be registered
$desthost = '<esxi-dest-host>'

# if the host is part of a cluster, you will need to specify the cluster instead
$destClust = '<vcenter-cluster-name>'

# datastore to put the clones
$destdatastore = '<datastore-name>'
##########################################################################################

#Write-Output ">>> Import the TintriPowershellToolkit module.`n"
ipmo 'C:\Program Files\TintriPSToolkit\TintriPSToolkit.psd1'

Write-Output ">>> Connect to a tintri server $tintriserver.`n"
Connect-TintriServer -Server $tintriserver -UserName $tsusername -Password $tspassword

#Write-Output ">>> Get LatestSnapshot for VM $vmname. `n"
#$latestSnap = Get-TintriVMSnapshot -Name $vmname -GetLatestSnapshot

#Write-Output ">>> Get HostResource Object for ESXi Host $desthost. `n"
#$vhr = Get-TintriVirtualHostResource -DisplayName $desthost -VirtualHostResourceType ComputeResource
$vhr = Get-TintriVirtualHostResource -DisplayName $destClust -VirtualHostResourceType ClusterComputeResource
$vhr

#Write-Output ">>> Get Host Datastore Object for ESXi Host $desthost. `n"
$vhds = Get-TintriHypervisorDatastore -DisplayName $destdatastore
$vhds

#Write-Output ">>> Create a clone for VM $vmname.`n"
#New-TintriVMClone -SourceVMName $vmname -NewVMCloneName $clonebasename -VMHostResource $vhr -HypervisorDatastore $vhds -SnapshotConsistency CRASH_CONSISTENT

#Write-Output ">>> Get LatestSnapshot for VM $vmname. `n"
#$latestSnap = Get-TintriVMSnapshot -Name $vmname -GetLatestSnapshot

# assign the snapshot we want to clone from
$baseSnap = Get-TintriVMSnapshot -Name $vmname -SnapshotDescription $snapdescription
$baseSnap

# drop the last two characters of the guest OS name. this will be used to form the new name
$vmbaseFix = $clonebasename.substring(0,$clonebasename.length-2)

while ($i -le $e) {

    # force the counter to be two digits
    $a = "{0:D2}" -f $i

    $vmclonename = $vmbaseFix + $a
    $vmclonename
    
    New-TintriVMClone -SourceVMName $vmname -NewVMCloneName $vmclonename -VMHostResource $vhr -HypervisorDatastore $vhds -SourceSnapshot $baseSnap
    
    echo "created clone $vmclonename"
    
    $i++
}

#disconnect from tintri server
write-host "Disconnecting from $tintriserver"
#disconnect-tintriserver -hostname $tintriserver -Verbose
