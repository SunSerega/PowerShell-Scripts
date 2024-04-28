try {
	
	
	
	$files = @()
	foreach ($arg in $args) {
		if (Test-Path -LiteralPath $arg -PathType Container) {
			$files += Get-ChildItem -Path $arg -Recurse -File | ForEach-Object {
				$_.FullName
			}
		} elseif (Test-Path -LiteralPath $arg -PathType Leaf) {
			$files += $arg
		} else {
			Write-Host "$arg does not exist"
		}
	}
	
	$files = $files | Where-Object {
		$_ -match "\.(mkv|webm|mp4|gif)$"
	}
	
	if ($files.Count -eq 0) {
		throw "No files selected";
	}
	
	$tempFile = [System.IO.Path]::GetTempFileName()
	
	$orderedFiles = $files | Sort-Object
	
	$utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $false
	[System.IO.File]::WriteAllText($tempFile, "`n", $utf8NoBomEncoding)
	
	$orderedFiles | ForEach-Object {
		"file '$($_ -replace "'", "`'`'")'" | Out-File -FilePath $tempFile -Append -Encoding utf8
	}
	
	function Get-LongestCommonPrefix {
		param([string[]]$strings)

		$prefix = $strings[0]
		for ($i = 1; $i -lt $strings.Length; $i++) {
			while (-not $strings[$i].StartsWith($prefix)) {
				$prefix = $prefix.Substring(0, $prefix.Length - 1)
				if ($prefix -eq '') {
					return ''
				}
			}
		}
		return $prefix
	}
	
	$outputFile = (Get-LongestCommonPrefix $args) + ' - combined.mp4'
	
	Write-Host 'ffmpeg -f concat -safe 0 -i "'$tempFile'" -c copy "'$outputFile'"'
	ffmpeg -f concat -safe 0 -i "$tempFile" -c copy "$outputFile"
	
	Remove-Item -Path $tempFile
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
	exit 1
}
#pause