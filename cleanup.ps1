$vcentervm = "vcsa"
$vcenterip = "10.10.5.10"
$vcenterpw = "VMware1!"
$esxis = @("10.10.5.250", "10.10.5.251")
$esxipassword = 'VMware1!'

foreach ($esxi in $esxis) {
    connect-viserver -server $esxi -user root -password $esxipassword -ErrorAction Stop
    Get-VM -Name vcf-* | Stop-VM -Confirm:$false -ErrorAction SilentlyContinue
    Get-VM -Name vcf-* | Remove-VM -DeletePermanently -Confirm:$false
    if (Get-VM -Name $vcentervm -ErrorAction SilentlyContinue) {
        Get-VM -Name $vcentervm | Start-VM
    }
    Disconnect-VIServer -server $esxi -Confirm:$false -ErrorAction SilentlyContinue
}

sleep 600

connect-viserver -server $vcenterip -user $vcenteruser -password $vcenterpw
Get-VApp -Name 'Nested-VCF-*' | Remove-VApp -DeletePermanently -Confirm:$false
disconnect-viserver * -Confirm:$false