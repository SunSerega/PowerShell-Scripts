try {
	
	
	
	if ($args.Length -ne 1) {
		throw "Expected 1 argument: $args"
	}
	$inp_fname = $args[0]
	if (-not [IO.File]::Exists($inp_fname)) {
		throw "File [$inp_fname] does not exist"
	}
	Set-Location -LiteralPath (Split-Path $inp_fname)
	
	$inp_name = [IO.Path]::GetFileNameWithoutExtension($inp_fname)
	$inp_ext = [IO.Path]::GetExtension($inp_fname)
	
	
	
	foreach ($l in ffprobe -print_format csv -show_chapters $inp_fname 2>nul) {
		$parts = $l -split ','
		
		$start = $parts[4]
		$end = $parts[6]
		$chapter = $parts[7]
		
		Write-Host "ffmpeg -nostdin -ss $start -to $end -i '$inp_fname' -map 0 -map_chapters -1" "'$inp_name - $chapter$inp_ext'"
		ffmpeg -nostdin -ss $start -to $end -i $inp_fname -map 0 -map_chapters -1 "$inp_name - $chapter$inp_ext"
		
	}
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
	exit 1
}
#pause