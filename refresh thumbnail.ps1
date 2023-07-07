try {
	
	
	
	$currentFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
	
	$ps1Files = Get-ChildItem -Path $currentFolder -Filter "*.ps1" | Where-Object { $_.FullName -ne $MyInvocation.MyCommand.Path }
	
	$sendToFolder = [System.Environment]::GetFolderPath("SendTo")
	
	foreach ($file in $ps1Files) {
		$shortcutPath = Join-Path -Path $sendToFolder -ChildPath "$($file.BaseName).lnk"
		$wScriptShell = New-Object -ComObject WScript.Shell
		$shortcut = $wScriptShell.CreateShortcut($shortcutPath)
		$shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
		$shortcut.Arguments = "-File `"$($file.FullName)`""
		$shortcut.Save()
	}
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
}
#pause