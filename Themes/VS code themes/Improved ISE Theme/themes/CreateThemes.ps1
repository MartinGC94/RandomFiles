$ThemeData=Get-Content -Path "$PSScriptRoot\ThemeData.json" -Raw | ConvertFrom-Json
[pscustomobject]@{
    name="ISE Dark Theme"
    colors=$ThemeData.DarkColors
    tokenColors=$ThemeData.tokenColors | Select-Object -ExcludeProperty DarkSettings,LightSettings -Property *,@{Name="settings";Expression={$_.DarkSettings}}
} | ConvertTo-Json -Depth 5 -Compress | Set-Content -Path "$PSScriptRoot\ISE-Dark-Theme.json"
[pscustomobject]@{
    name="ISE Light Theme"
    colors=$ThemeData.LightColors
    tokenColors=$ThemeData.tokenColors | Select-Object -ExcludeProperty DarkSettings,LightSettings -Property *,@{Name="settings";Expression={$_.LightSettings}}
} | ConvertTo-Json -Depth 5 -Compress | Set-Content -Path "$PSScriptRoot\ISE-Light-Theme.json"