try {
	
	
	
	$files = @()
	foreach ($arg in $args) {
		if (Test-Path $arg -PathType Container) {
			$files += Get-ChildItem -Path $arg -Recurse -File | Select-Object -ExpandProperty FullName
			#$files += Get-ChildItem -Path $arg -Recurse -Directory | Select-Object -ExpandProperty FullName
			$files += $arg
		} elseif (Test-Path $arg -PathType Leaf) {
			$files += $arg
		}
	}
	
	foreach ($fileName in $files) {
		
		$retryCount = 10
		while ($retryCount -gt 0) {
			try {
				Write-Host $fileName
				$file = Get-Item -LiteralPath "$fileName"
				Write-Host $file | Format-List
				$file.LastWriteTime = Get-Date
				break
			}
			catch {
				if ($retryCount -eq 1) {
					Write-Host "Could not modify lwt"
					break
				}
				Start-Sleep -Milliseconds 100
				$retryCount--
			}
		}
		
	}
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
	exit
}
#pause