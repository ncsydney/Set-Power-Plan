$activePowerPlan = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "IsActive = 'True'" | Select-Object -ExpandProperty ElementName
Write-Host "`nCurrent power plan: $activePowerPlan`n" -ForegroundColor Green
while ($true) {
    $allPowerPlans = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan | Select-Object -ExpandProperty ElementName

    $num = 0
    $plansList = @()

    foreach($plan in $allPowerPlans){
        Write-Host "$num) $plan" -ForegroundColor DarkYellow
        $num+=1
        $plansList += $plan
    }
    Write-Host "$num) Exit" -ForegroundColor Red

    $choice = Read-Host "Choose a Power Plan"
    if ($choice -eq $num){
        Pause
        break
    }
    elseif ($choice -gt $num){
        Write-Host "`nThat power plan does not exist!`n" -ForegroundColor Red
    }
    else {    
        $setPowerPlan = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = '$($plansList[$choice])'" 
        powercfg /s ($setPowerPlan.InstanceID).Replace("Microsoft:PowerPlan\{","").Replace("}","")
        $newActivePowerPlan = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "IsActive = 'True'" | Select-Object -ExpandProperty ElementName

        Write-Host "`nCurrent power plan: $newActivePowerPlan`n" -ForegroundColor Green
    }
}