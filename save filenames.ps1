try {
	
	
	
	if ($args.Length -ne 1) {
		$err = "Expected 1 argument, got:"
		foreach($arg in $args) {
			$err += "`n- "
			$err += $arg
		}
		throw $err
	}
	
	$dir = $args[0];
	if (-not [IO.Directory]::Exists($dir)) {
		throw "[$dir] is not a directory"
	}
	
	$otp_fname = $dir + '.filenames.log'
	foreach ($item in Get-ChildItem -LiteralPath $dir -Recurse | Sort-Object) {
		$path = $item.FullName
		if ([IO.Directory]::Exists($path)) {
			$path += '\'
		}
		Write-Host $path
		$path >> $otp_fname
	}
	
	& $otp_fname
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
	exit 1
}
#pause