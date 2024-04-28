try {
	$anyWarnings = $false;
	
	
	
	$files = @()
	foreach ($arg in $args) {
		if (Test-Path -LiteralPath $arg -PathType Container) {
			$files += Get-ChildItem -LiteralPath $arg -Recurse -File | ForEach-Object {
				$_.FullName
			}
		} else {
			Write-Host "[$arg] is not a folder"
			$anyWarnings = $true
		}
	}
	
	if ($files.Count -eq 0) {
		throw "No files selected";
	}
	
	foreach ($file in $files) {
		#Write-Host "File: $file"
	}
	
	$parentDirectory = Split-Path -Parent -Path $args[0]
	foreach ($arg in $args) {
		$dir = Split-Path -Parent -Path $arg
		if ($dir -ne $parentDirectory) {
			throw "No everythign is in the same directory: [$parentDirectory] vs [$dir]"
		}
	}
	
	if ($anyWarnings) {
		Write-Host "Are you sure you want to continue?"
		pause
	}
	
	foreach ($file in $files) {
		#Write-Host $"[$file] relative to [$parentDirectory]"
		$relativePath = Resolve-Path $file -RelativeBasePath $parentDirectory -Relative
		#Write-Host $"[$relativePath]"
		
		if (-not $relativePath.StartsWith(".\")) {
			throw "[$file] is not in [$parentDirectory]"
		}
		$relativePath = $relativePath.Substring(".\".Length)
		
		$n_file = Join-Path $parentDirectory ($relativePath -replace '\\', ' + ')
		Move-Item -LiteralPath $file -Destination $n_file -ErrorAction Stop
	}
	
	Write-Host "Deleting leftover folders"
	foreach ($arg in $args) {
		if (Test-Path -LiteralPath $arg -PathType Container) {
			$files_left = Get-ChildItem -LiteralPath $arg -Recurse -File
			if ($files_left.Length -ne 0) {
				throw "There are still files in [$arg]"
			}
			Remove-Item -LiteralPath $arg -Recurse
		}
	}
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
	exit 1
}
pause