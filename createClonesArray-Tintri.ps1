#########################################################
#														#
#	This script will clone vms from a tintri snapshot   #
#	and register the vm in vcenter.						#
#													  mr#
#########################################################
#
# Date:		9 Sept 2014
# Changes:	Initial code
# Version:	1.0.0
#
# Date:		9 Sept 2014
# Changes:  Added more documentation
# Version:	Not changed
#
# Date:		29 Jan 2015
# Changes:  Added email notification, documenation and using an array for vms
# Version:	2.0.0
##########################################################################################

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
  [string] $snapdescription,
  [string] $smtpTo,
  [string] $smtpFrom,
  [string] $messageSubject,
  [string] $messageBody,
  [string] $messagePriority
)

##########################################################################################
# Function declarations
##########################################################################################

function sendMail {
    <#
    .SYNOPSIS
    This function will accept arguments and send a message
    .DESCRIPTION
    Call this function name and pass it 6 arguments to send a message
    .EXAMPLE
    sendMail -smtpFrom "user@nsslabs.com" -smtpTo "user@nsslabs.com" -messageSubject "test message" -messageBody "test message body" -messagePriority "High" -mailServer "smtp.gmail.com"
    #>

    # function argument parameters
    param (
        [string]$smtpFrom,
        [string]$smtpTo,
        [string]$messageSubject,
        [string]$messageBody,
        [string]$messagePriority,
        [string]$mailServer
    )

    # write to console that we are sending a message
    write-host "Sending email" -ForegroundColor Green

    # send the message using the function arguments
    Send-MailMessage -from $smtpFrom -to $smtpTo -Subject $messageSubject -Body $messageBody -Priority $messagePriority -SmtpServer $mailServer

}

##########################################################################################
# End Function declarations
##########################################################################################

##########################################################################################
# Global variables
##########################################################################################

# smtp info
$smtpTo = 'mrussell@nsslabs.com'
$smtpFrom = 'TestLabScript@nsslabs.com'
$messagePriority = 'High'
$mailServer = 'nsslabs-com.mail.protection.outlook.com'

##########################################################################################

# entries for TINTRI-01
# ONLY USE ONE OF THESE
#$tintriserver = 'tintri-01.testlab.nsslabs.com'

# entries for TINTRI-02
# ONLY USE ONE OF THESE
#$tintriserver = 'tintri-03.testlab.nsslabs.com'

# entries for TINTRI-03
# ONLY USE ONE OF THESE
#$tintriserver = 'tintri-03.testlab.nsslabs.com'

# entries for TINTRI-04
# ONLY USE ONE OF THESE
#$tintriserver = 'tintri-04.testlab.nsslabs.com'

# entries for TINTRI-05
# ONLY USE ONE OF THESE
$tintriserver = 'tintri-05.testlab.nsslabs.com'

# tintri username and password
$tsusername = 'admin'
$tspassword = 'N55L@bs'

##########################################################################################

# the esxi host where the vms will be registered
$desthost = 'r211-c14h2-lom1.testlab.nsslabs.com'

# if the host is part of a cluster, you will need to specify the cluster instead - NOT USED
#$destClust = 'networkstack'

# datastore to put the clones
$destdatastore = 'bds2e2-t5'

##########################################################################################

# the name of the vm or template that you want to clone
#$vmname = 'Tintri04-VMW5-5-Win7SP1-X86-Cntrl-Proxy-Master-Template'

#$vmname = 'Tintri05-VMW5-5-WinXPSP3-X86-IE6-Master-Template'
#$vmname = 'Tintri05-VMW5-5-WinXPSP3-X86-IE7-Master-Template'
#$vmname = 'Tintri05-VMW5-5-WinXPSP3-X86-IE8-Master-Template'
#$vmname = 'Tintri05-VMW5-5-Win7-X86-IE8-Master-Template'
#$vmname = 'Tintri05-VMW5-5-Win7SP1-X64-IE8-Master-Template'
#$vmname = 'Tintri05-VMW5-5-Win8-X64-IE10DT-Master-Template'
#$vmname = 'Tintri05-VMW5-5-Win8-1-X64-IE11DT-Master-Template'
#$vmname = 'Tintri05-VMW5-5-Win7SP1-X86-IE9-JRE1-BDS-TestSuite-Template'
#$vmname = 'Tintri05-VMW5-5-Win7SP1-X86-IE9-JRE2-BDS-TestSuite-Template'
#$vmname = 'Tintri05-VMW5-5-Win7SP1-X86-IE9-JRE3-BDS-TestSuite-Template'
$vmname = 'Tintri05-VMW5-5-Win7SP1-X86-IE9-JRE4-BDS-TestSuite-Template'

#$vmname = 'Tintri05-VMW5-5-Win7SP1-X86-IE10-EPP-Victim-Malware-TestSuite-Template'

# array of clone names, this will show up in vcenter
$vms = (
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
''
)

##########################################################################################

# name of the stack you want to make clones for
$stack = '<name>'

# Vendor name that you are making clones for
#$vendor = '<name>'

# date of the snapshot - format = yyyymmdd
$date = '20150617'

# the snapshot to base the tintri clones off of
#$snapdescription = '<description'
#$snapdescription = "$vmname-Snap-$stack-$vendor-$date"
$snapdescription = "$vmname-Snap-$stack-$date"

##########################################################################################

#Write-Output ">>> Import the TintriPowershellToolkit module.`n"
ipmo 'C:\Program Files\TintriPSToolkit\TintriPSToolkit.psd1'

Write-Output "Connect to a tintri server $tintriserver.`n"
Connect-TintriServer -Server $tintriserver -UserName $tsusername -Password $tspassword

#Write-Output ">>> Get LatestSnapshot for VM $vmname. `n"
#$latestSnap = Get-TintriVMSnapshot -Name $vmname -GetLatestSnapshot

# assign the computer resource to the vhr variable
Write-Output "Get HostResource Object for ESXi Host $desthost"
$vhr = Get-TintriVirtualHostResource -DisplayName $desthost -VirtualHostResourceType ComputeResource

# display the contents of the HostResource variable
write-output "Contents of vhr variable`n"
$vhr

# use this command is if the resource is a cluster
#$vhr = Get-TintriVirtualHostResource -DisplayName $destClust -VirtualHostResourceType ClusterComputeResource
#$vhr

# assign the datastore resource to the vhds variable
Write-Output "Get Host Datastore Object for ESXi Host $desthost"
$vhds = Get-TintriHypervisorDatastore -DisplayName $destdatastore

#check to see if the get host datastore object command returns more that one element
$i = $vhds.count

# display the contents of the Host Datastore Object variable
write-output "Contents of the vhds variable`n"
$vhds

#Write-Output ">>> Create a clone for VM $vmname.`n"
#New-TintriVMClone -SourceVMName $vmname -NewVMCloneName $clonebasename -VMHostResource $vhr -HypervisorDatastore $vhds -SnapshotConsistency CRASH_CONSISTENT

#Write-Output ">>> Get LatestSnapshot for VM $vmname. `n"
#$latestSnap = Get-TintriVMSnapshot -Name $vmname -GetLatestSnapshot

# assign the snapshot we want to clone from and check if it returns more than one snapshot by counting the array
$bSnap = Get-TintriVMSnapshot -Name $vmname -SnapshotDescription $snapdescription
$c = $bSnap.count

# check to see if there is more than one snapshot returned with the same snapshot description for the same vm, and select the first instance
if ($c -gt 1) {
    $baseSnap = $bSnap[$c-1]
}

else {
    $baseSnap = $bSnap
}

# display the contents of the baseSnap variable
write-host "Snapshot to use is $baseSnap" -ForegroundColor Blue

foreach ($vm in $vms) {

#    New-TintriVMClone -SourceVMName $vmname -NewVMCloneName $vm -VMHostResource $vhr -HypervisorDatastore $vhds -SourceSnapshot $baseSnap
#    New-TintriVMClone -SourceVMName $vmname -NewVMCloneName $vm -VMHostResource $vhr -HypervisorDatastore $vhds[0] -SourceSnapshot $baseSnap

#run the right command depending on how many hypervisor datastores the tintri see
    if ($i -gt 1) {
        Write-host "More than 1 item returned for the vhds variable`n" -foregroundcolor red
        New-TintriVMClone -SourceVMName $vmname -NewVMCloneName $vm -VMHostResource $vhr -HypervisorDatastore $vhds[0] -SourceSnapshot $baseSnap
    }

    else {
        Write-host "Only 1 item returned for the vhds variable`n" -ForegroundColor Blue
        New-TintriVMClone -SourceVMName $vmname -NewVMCloneName $vm -VMHostResource $vhr -HypervisorDatastore $vhds -SourceSnapshot $baseSnap
    }

    echo "created clone for $vm using $vmname and $baseSnap"

}

# disconnect from tintri server
write-host "Disconnecting from $tintriserver"
disconnect-tintriserver -hostname $tintriserver -Verbose

# send a message that the snapshots completed
sendMail -smtpFrom $smtpFrom -smtpTo $smtpTo -messageSubject "Clone VMs Script Completed" -messageBody "Make sure everything is good." -messagePriority $messagePriority -mailServer $mailServer
