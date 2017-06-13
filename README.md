# MirrorUserRG.ps1

#####Please be gentle, new Github User and Powershell n00b#####

.Synopsis

The Powershell script I have included is designed to take a user in powershell and mirror the response groups of another user, first      deleting any response groups the user that is being updated has. It includes a 1 minute sleep timer to ensure replication can occur, in case there is any duplication of response groups.

.Parameters

    -User1: Mandatory, this is the user whose settings you are mirroring FROM
    -User2: Mandatory, this is the user whose settings you are mirroring TO


.Example

   PS C:\> .\MirrorUserRG.ps1 -User1 "sip:name@domain.com" -User2 "sip:name@domain.com"
