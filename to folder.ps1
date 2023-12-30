try {
	$anyWarnings = $false;
	
	
	
	$files = @()
	foreach ($arg in $args) {
		if (Test-Path -LiteralPath $arg -PathType Leaf) {
			$files += $arg
		}
		elseif (Test-Path -LiteralPath $arg) {
			Write-Host "$arg is not a file"
			$anyWarnings = $true
		}
		else {
			Write-Host "$arg does not exist"
			$anyWarnings = $true
		}
	}
	
	if ($files.Count -eq 0) {
		throw "No files selected";
	}
	
	$fileName = Split-Path -Leaf -Path $files[0]
	
	$folderName = "";
	if ($fileName -match '^[^\d]*(\d+)') {
		$folderName = $Matches[1]
	}
	if ($userFolderName = Read-Host "Folder name [$folderName]") {
		$folderName = $userFolderName
	}
	if (!$folderName) {
		throw "No folder name"
	}
	
	$parentDirectory = Split-Path -Parent -Path $files[0]
	
	$newFolderPath = Join-Path -Path $parentDirectory -ChildPath $folderName
	
	if ($anyWarnings) {
		pause
	}
	
	if (Test-Path -LiteralPath $newFolderPath) {
		Write-Host $newFolderPath
		throw "folder already exists"
	}
	New-Item -ItemType Directory -Path $newFolderPath
	
	foreach ($file in $files) {
		$destination = Join-Path -Path $newFolderPath -ChildPath (Split-Path -Leaf -Path $file)
		Move-Item -LiteralPath $file -Destination $destination
	}
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
	exit 1
}
#pause