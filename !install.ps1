try {
	
	
	
	$installerFileName = $MyInvocation.MyCommand.Path
	
	$currentFolder = Split-Path -Parent $installerFileName
	
	$ps1Files = Get-ChildItem -Path $currentFolder -Filter "*.ps1" | Where-Object { $_.FullName -ne $installerFileName }
	
	$sendToFolder = [System.Environment]::GetFolderPath("SendTo")
	
	foreach ($file in $ps1Files) {
		Write-Host $file.FullName
		$shortcutPath = Join-Path -Path $sendToFolder -ChildPath "+$($file.BaseName).lnk"
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
	exit
}
#pause