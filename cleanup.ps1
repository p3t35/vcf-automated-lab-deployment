$vcentervm = "vcsa"
$vcenterip = "10.10.5.10"
$vcenterpw = "VMware1!"
$esxis = @("10.10.5.250", "10.10.5.251")
$esxipassword = 'VMware1!'

foreach ($esxi in $esxis) {
    Connect-VIserver -server $esxi -user root -password $esxipassword 
    Get-VM -Name vcf-* | Stop-VM -Confirm:$false
    Get-VM -Name vcf-* | Remove-VM -DeletePermanently -Confirm:$false
    if (Get-VM -Name $vcentervm -ErrorAction SilentlyContinue) {
        Get-VM -Name $vcentervm | Start-VM
    }
    Disconnect-VIServer -server 10.10.5.250 -Confirm:$false 
}

while ($true) {
    try {
        Connect-VIserver -server $vcenterip -user administrator@vsphere.local -password $vcenterpw
        Get-VApp -Name 'Nested-VCF-*' | Remove-VApp -DeletePermanently -Confirm:$false -ErrorAction SilentlyContinue
        Disconnect-VIServer * -Confirm:$false 
        exit
    }
    catch {
        Write-Host "Sleep 1min and try to connect to vcenter"
        sleep 60
    }
}