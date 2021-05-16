$ThemeData=Get-Content -Path "$PSScriptRoot\ThemeData.json" -Raw | ConvertFrom-Json
[pscustomobject]@{
    name="Powershell Dark Theme"
    colors=$ThemeData.DarkColors
    tokenColors=$ThemeData.tokenColors | Select-Object -ExcludeProperty DarkSettings,LightSettings -Property *,@{Name="settings";Expression={$_.DarkSettings}}
} | ConvertTo-Json -Depth 5 -Compress | Set-Content -Path "$PSScriptRoot\Powershell-Dark-Theme.json"
[pscustomobject]@{
    name="Powershell Light Theme"
    colors=$ThemeData.LightColors
    tokenColors=$ThemeData.tokenColors | Select-Object -ExcludeProperty DarkSettings,LightSettings -Property *,@{Name="settings";Expression={$_.LightSettings}}
} | ConvertTo-Json -Depth 5 -Compress | Set-Content -Path "$PSScriptRoot\Powershell-Light-Theme.json"