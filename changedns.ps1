param (
    [Parameter(Position=0)]
    [ValidateSet("Set", "Reset")]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$Interface,

    [Parameter(Position=2)]
    [string]$PrimaryDNS,

    [Parameter(Position=3)]
    [string]$SecondaryDNS
)

function Show-Help {
    Write-Host "Usage: changedns -Action <Set|Reset> -Interface <NETWORK_INTERFACE> [-PrimaryDNS <DNS_SERVER>] [-SecondaryDNS <SECONDARY_DNS_SERVER>]"
    Write-Host ""
    Write-Host "Actions:"
    Write-Host "  Set     Set DNS servers for the specified network interface."
    Write-Host "  Reset   Reset DNS servers to automatic configuration."
    Write-Host ""
    Write-Host "Parameters:"
    Write-Host "  -Interface      Name of the network interface (mandatory)."
    Write-Host "  -PrimaryDNS     Primary DNS server (mandatory for 'Set' action)."
    Write-Host "  -SecondaryDNS   Secondary DNS server (optional)."
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\changedns.ps1 -Action Set -Interface 'Ethernet' -PrimaryDNS '8.8.8.8' -SecondaryDNS '8.8.4.4'"
    Write-Host "  .\changedns.ps1 -Action Reset -Interface 'Ethernet'"
}

function Set-DNS {
    param (
        [string]$Interface,
        [string]$PrimaryDNS,
        [string]$SecondaryDNS
    )

    $interfaceIndex = (Get-NetAdapter -Name $Interface).ifIndex

    if ($null -eq $interfaceIndex) {
        Write-Error "The interface '$Interface' was not found."
        return
    }

    # Set the primary DNS server
    Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses $PrimaryDNS

    # If a secondary DNS server is provided, set it as well
    if ($SecondaryDNS) {
        Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses @($PrimaryDNS, $SecondaryDNS)
    }

    Write-Output "DNS servers successfully set for interface '$Interface'."
}

function Reset-DNS {
    param (
        [string]$Interface
    )

    $interfaceIndex = (Get-NetAdapter -Name $Interface).ifIndex

    if ($null -eq $interfaceIndex) {
        Write-Error "The interface '$Interface' was not found."
        return
    }

    # Reset DNS configuration to automatic
    Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ResetServerAddresses

    Write-Output "DNS servers reset to automatic for interface '$Interface'."
}

# Validate parameters and show help if necessary
if (-not $Action -or -not $Interface -or ($Action -eq "Set" -and -not $PrimaryDNS)) {
    Show-Help
    exit
}

# Perform action
if ($Action -eq "Set") {
    Set-DNS -Interface $Interface -PrimaryDNS $PrimaryDNS -SecondaryDNS $SecondaryDNS
} elseif ($Action -eq "Reset") {
    Reset-DNS -Interface $Interface
}

# Display current DNS configuration
Get-DnsClientServerAddress -InterfaceAlias $Interface
