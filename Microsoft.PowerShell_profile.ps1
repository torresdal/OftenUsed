
# Load posh-git example profile
. 'C:\Users\admin\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'

$sublimePath = "C:\Program Files\Sublime Text 2\sublime_text.exe"

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
			write-error "Could not find any files matching $FileName" 
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

