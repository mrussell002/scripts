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
# Changes:  Added email notification, documenation and using an array for vms and bunch of other stuff
# Version:	2.0.0
#
# Date:		16 April 2015
# Changes:  Changed output to have each entry on its own line instead of old format
# Version:  2.1.0
##########################################################################################

Param(
  [string] $source,
  [string] $dest,
  [string] $tempfile,
  [string] $subnet,
  [string] $start,
  [string] $end,
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
$mailServer = '<mail-server>'
$smtpTo = '<dest-email>'
$smtpFrom = '<from-email>'
$messagePriority = 'High'

##########################################################################################

# source and destination files
$source = '<location>'
$dest = '<location>'

# file used to temporarily store some info.  will be deleted at the end of script
$tempfile = 'c:\temp\tempfile.txt'
$tempfile2 = 'c:\temp\tempfile2.txt'

##########################################################################################

# Network address to look for when doing the proper format
$subnet = "10."

##########################################################################################

# counters for the amount of clones per set
# this number will be converted to a 2 digit number in the loop
# it will handle up to 99, if you need over 99, you need to modify the
# converion to handle it.
#$start = 1
#$end = 9

##########################################################################################
# End Global variables
##########################################################################################


# delete the destionation file if it exists
if (test-path $dest) {
    remove-item $dest
}

# add "host" to the beginning of each line
(Get-Content $source) | ForEach-Object { Add-Content $tempfile "host $_" }

# format the end of each line
(get-content $tempfile) | ForEach-Object { add-content $tempfile2 "$_; `}" }

# remove the tab before the mac address and add "hardware ethernet"
(get-content $tempfile2) | foreach-object { $_ -replace "`t00:50:56", " { hardware ethernet 00:50:56" } | set-content $dest

# remove the tab after the mac address and add ; to mac address and "fixed-address" to ip address
(get-content $dest) | foreach-object { $_ -replace "`t$subnet", "; fixed-address $subnet" } | set-content $dest

# perform cleanup
if (test-path $tempfile) {
    Remove-Item $tempfile
    Remove-Item $tempfile2
}

# send message that nic add completed
sendMail -smtpFrom $smtpFrom -smtpTo $smtpTo -messageSubject "DHCP Reservation File Complete" -messageBody "Verify things are correct.`n$nCount nics added to $vCount vms`n" -messagePriority $messagePriority -mailServer $mailServer
