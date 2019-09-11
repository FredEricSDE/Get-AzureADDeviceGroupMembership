# Check if connected to AzureAD. If not - connect.

if($AzureADConnection.Account -eq $null)
{
    $AzureADConnection = Connect-AzureAD
}

# Prompt for Device Name

$DeviceName = Read-Host -Prompt 'DeviceName to Search for'

# Get All Groups and Devices, then check what Groups a certain Device is Member of...

Function Get-AzureADDeviceGroupMembership
{
    $AzureAdGroups = Get-AzureADGroup -All $true
    $AzureADDevices = Get-AzureADDevice -All $true
    $Result = @()

    Foreach ($Group in $AzureADGroups)
    {
        $Members = Get-AzureADGroupMember -ObjectId $Group.ObjectID
    
        Foreach ($Device in $AzureADDevices)
        {
            if (($Members.DeviceID -Match $Device.DeviceID) -and ($Device.DisplayName -like "$DeviceName"))
            {
                $Result += $Group.DisplayName
            }

        }
    }

    $Result | fl
}

Get-AzureADDeviceGroupMembership