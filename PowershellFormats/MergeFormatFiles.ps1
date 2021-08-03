<#
.SYNOPSIS
    Combines multiple ps1xml format files into one big file, for faster loading.
.PARAMETER Path
    The format files to merge
.PARAMETER Destination
    The destination filename for the output file
#>
using namespace System.Management.Automation
param
(
    [Parameter(Mandatory)]
    [string[]]
    $Path,

    [Parameter(Mandatory)]
    [string]
    $Destination
)
[xml]$BaseXML=@"
<?xml version="1.0" encoding="utf-8" ?> 
<Configuration>
  <DefaultSettings/>
  <SelectionSets/>
  <Controls/>
  <ViewDefinitions/>
</Configuration>
"@
$XpathsToCopyFrom=@(
    '/Configuration/DefaultSettings'
    '/Configuration/SelectionSets'
    '/Configuration/Controls'
    '/Configuration/ViewDefinitions'
)

$ErrorActionPreference = [ActionPreference]::Stop
try
{
    foreach ($XML in [xml[]](Get-Content -Raw -Path $Path))
    {
        foreach ($Xpath in $XpathsToCopyFrom)
        {
            $TargetNode = $BaseXML.SelectSingleNode($Xpath)
            $SourceNode = $XML.SelectSingleNode($Xpath)
            if ($null -ne $SourceNode)
            {
                $DataToImport = $BaseXML.ImportNode($SourceNode,$true)
                foreach ($ChildNode in $DataToImport.ChildNodes)
                {
                    $null = $TargetNode.AppendChild($ChildNode)
                }
            }
        }
    }
    foreach ($Xpath in $XpathsToCopyFrom)
    {
        $FoundNode = $BaseXML.SelectSingleNode($Xpath)
        if ($FoundNode.ChildNodes.Count -eq 0)
        {
            $null = $BaseXML.Configuration.RemoveChild($FoundNode)
        }
    }
    $BaseXML.Save($Destination)
}
catch
{
    throw $_
}