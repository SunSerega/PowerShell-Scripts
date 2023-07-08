try {
	
	
	
	$files = @()
	foreach ($arg in $args) {
		if (Test-Path $arg -PathType Leaf) {
			$files += $arg
		}
	}
	
	if ($files.Count -eq 0) {
		throw "No files selected";
	}
	
	$fileName = Split-Path -Path $files[0] -Leaf
	
	if ($fileName -match '^\d+') {
		$folderName = $Matches[0]
	}
	else {
		throw "No digits at the beginning of the file name."
	}
	
	$parentDirectory = Split-Path -Path $files[0] -Parent
	
	$newFolderPath = Join-Path -Path $parentDirectory -ChildPath $folderName
	
	if (Test-Path -Path $newFolderPath) {
		Write-Host $newFolderPath
		throw "folder already exists"
	}
	New-Item -ItemType Directory -Path $newFolderPath
	
	foreach ($file in $files) {
		$destination = Join-Path -Path $newFolderPath -ChildPath (Split-Path -Path $file -Leaf)
		Move-Item -Path $file -Destination $destination
	}
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
	exit 1
}
#pause