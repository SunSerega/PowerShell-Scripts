try {
	
	
	
	$i = Get-Random ($args.Length)
	$arg = $args[$i]
	# Write-Host start $arg
	start $arg
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
	exit 1
}
# pause