
# Load posh-git example profile
. 'C:\Users\admin\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'

# Load AWS PowerShell Tools
import-module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"

$sublimePath = "C:\Program Files\Sublime Text 2\sublime_text.exe"

Set-Alias git "C:\Program Files\hub\hub.exe"

Function sln
{
	[CmdletBinding()]
	param (	[string] $solutionName = $null, [bool] $all = $false)

 	if($solutionName) {
		Invoke-Item $solutionName
	}
	else {
		if($all) {
			Invoke-Item *.sln
		}
		else {
			Get-ChildItem *.sln | Select-Object -First 1 | Invoke-Item
		}
	}
}

Function proj
{
	[CmdletBinding()]
	param (	[string] $projName = $null, [bool] $all = $false)

 	if($projName) {
		Invoke-Item $projName
	}
	else {
		if($all) {
			Invoke-Item *.csproj
		}
		else {
			Get-ChildItem *.csproj | Select-Object -First 1 | Invoke-Item
		}
	}
}

function sublime
{
	[CmdletBinding()]
	param ([string] $FileName = $null, [switch] $All, $Extension = $null)

	$newInstance = "-n"

	if($FileName) {
		$allFiles = Get-ChildItem $FileName
		if($allFiles) {
			if($allFiles -is [System.Array]) {
				& $sublimePath $newInstance $allFiles
			}
			else {
				& $sublimePath $allFiles
			}
		}
		else {
			touch $FileName
			& $sublimePath $FileName
		}
	}
	else {
		if($Extension) {
			$allFiles = Get-ChildItem $Extension
			& $sublimePath $newInstance $allFiles
		}
		elseif($All) {
			$allFiles = Get-ChildItem *.*
			& $sublimePath $newInstance $allFiles
		}
		else {
			& $sublimePath $newInstance
		}
	}
}

function touch {
	[CmdletBinding()]
	param (	[string] $filename)

	echo $null > $filename
}

function Write-Color-LS
{
	param ([string]$color = "white", $file)
	Write-host ("{0,-7} {1,25} {2,10} {3}" -f $file.mode, ([String]::Format("{0,10}  {1,8}", $file.LastWriteTime.ToString("d"), $file.LastWriteTime.ToString("t"))), $file.length, $file.name) -foregroundcolor $color 
}

New-CommandWrapper Out-Default -Process {
    $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase)


    $compressed = New-Object System.Text.RegularExpressions.Regex(
        '\.(zip|tar|gz|rar|jar|war)$', $regex_opts)
    $executable = New-Object System.Text.RegularExpressions.Regex(
        '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts)
    $text_files = New-Object System.Text.RegularExpressions.Regex(
        '\.(txt|cfg|conf|ini|csv|log|xml|java|c|cpp|cs)$', $regex_opts)

    if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
    {
        if(-not ($notfirst)) 
        {
           Write-Host
           Write-Host "    Directory: " -noNewLine
           Write-Host " $(pwd)`n" -foregroundcolor "Magenta"           
           Write-Host "Mode                LastWriteTime     Length Name"
           Write-Host "----                -------------     ------ ----"
           $notfirst=$true
        }

        if ($_ -is [System.IO.DirectoryInfo]) 
        {
            Write-Color-LS "Magenta" $_                
        }
        elseif ($compressed.IsMatch($_.Name))
        {
            Write-Color-LS "DarkGreen" $_
        }
        elseif ($executable.IsMatch($_.Name))
        {
            Write-Color-LS "Red" $_
        }
        elseif ($text_files.IsMatch($_.Name))
        {
            Write-Color-LS "Yellow" $_
        }
        else
        {
            Write-Color-LS "White" $_
        }

	$_ = $null
    }
} -end {
    write-host ""
}
