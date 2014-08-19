param(
    [switch] $noPush,
    [ValidateSet('Debug', 'Release')]
    [string] $cfg = 'Releasee'
)


$dir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
$sol = Get-ChildItem $dir -File -Filter *.proj | Select-Object -First 1

function Build-Project(){
    Param(
        [Parameter(Mandatory=$true)]
        [String] $proj,
        [String] $tgt = 'Build',
        [String] $v = 'm',
        [String] $props,
        [int] $m = 4
    )
    
    $msbuild = Get-MsBuild

    $opts = @("$proj", '/nologo', "/t:$tgt", "/m:$m", "/v:$v", ('/p:' + $props))

    & $msbuild $opts
    if($? -eq $false){
        throw "Build error! See above."
    }
}


function Get-MsBuild(){
    $msbuilds = @('12.0', '4.0')

    foreach($ver in $msbuilds)
    {
        $r = ('HKLM:\SOFTWARE\Microsoft\MSBuild\ToolsVersions\{0}' -f $ver)
        if(Test-Path $r)
        {
            $p = $r | Get-ItemProperty -Name 'MSBuildToolsPath' | Select-Object -ExpandProperty 'MSBuildToolsPath'
            return "$p\msbuild.exe"
        }
    }

    throw "MsBuild not found"
}

"Building NuGet Packages" | Write-Host -ForegroundColor Yellow
Build-Project -proj $sol.Name -tgt "NuGet" -props "Configuration=$cfg;NoPush=$noPush"
