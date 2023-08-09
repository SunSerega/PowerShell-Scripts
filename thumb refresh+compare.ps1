try {
	
	
	
	Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.IO.Pipes;
public class CS
{
	public static void AskRefresh(string[] paths)
	{
		using (var str = new NamedPipeClientStream("Dashboard for Thumbnailer"))
		{
			Console.WriteLine("Connecting...");
			str.Connect();
			
			var bw = new BinaryWriter(str);
			bw.Write(3); // Commands.LoadCompare
			bw.Write(paths.Length);
			foreach (var path in paths)
				bw.Write(path);
			
			str.Flush();
		}
	}
}
"@
	
	[CS]::AskRefresh($args)
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
	exit 1
}
#pause