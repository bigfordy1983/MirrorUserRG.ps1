<#
    .Synopsis
    This Script is designed to mirror Response Groups between one user and another, making response group management ad cloning of users much easier.

    .Parameters

    -User1: Mandatory, this is the user whose settings you are mirroring FROM
    -User2: Mandatory, this is the user whose settings you are mirroring TO

    .Example

   PS C:\> .\MirrorUserRG.ps1 -User1 "sip:name@domain.com" -User2 "sip:name@domain.com"

    
#>

param (

    [String]$User1,
    [String]$User2

    ) 


     foreach ($member in $User2) {
                Write-Host  "Removing $member"
                try {
                    $groupsContainingUser = Get-CsRgsAgentGroup | Where-Object {$_.AgentsByUri -contains $member}
                    Write-host  "$member is in $($groupsContainingUser.Count) groups"
                }
                catch {
                    Write-host "Unable to get response group information for user "
                }

                if($groupsContainingUser.Count -gt 0) {
                    foreach ($group in $groupsContainingUser) {
                        try{
                            Write-host  "Removing $member from $($group.Name)"
                            [void]$group.AgentsByUri.Remove($member)  
                            Set-CsRgsAgentGroup -Instance $group
                        }
                        catch {
                            Write-host  "Unable to remove $member from $($group.Name)"
                        }
                    }
                }

                else {
                    Write-host "Not attempting removal as $member was not in any response groups"
                }
   
            }

Write-Host "Pausing for 2 minutes to allow changes to replicate"

Start-Sleep -Seconds 120

Write-Host "Getting Response Groups to apply" 
 
 $ResponseGroup = Get-CsRgsAgentGroup | Where-Object{$_.AgentsbyURI -contains $User1} | Select-Object Identity, Name
        
            foreach ($member in $User2) {
                Write-host "Starting additions for $member"
                foreach($group in $ResponseGroup) {
                    try{
                        $Name = $group.identity
                        Write-host "Adding $member to" $group.name
                        $rg = Get-CsRgsAgentGroup -identity $Name
                        [void]$rg.AgentsByUri.Add($member)
                        Set-CsRgsAgentGroup -Instance $rg 
                    }
                    catch {
                        Write-host -Message "Unable to Add $member to" $group.Name
                    }
                }
            }
