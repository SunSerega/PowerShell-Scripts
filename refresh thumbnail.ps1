try {
	
	
	
	Add-Type -TypeDefinition `
@"
	using System;
	using System.Runtime.InteropServices;
	
	public class ThumbnailRefresh
	{
		private const int SHCNE_ASSOCCHANGED = 0x08000000;
		private const int SHCNF_IDLIST = 0x0000;
		private const int SHCNF_PATHW = 0x0005;
	
		[DllImport("shell32.dll", CharSet = CharSet.Auto, SetLastError = true)]
		private static extern void SHChangeNotify(int wEventId, int uFlags, [MarshalAs(UnmanagedType.LPWStr)] string dwItem1, IntPtr dwItem2);
	
		public static void RefreshThumbnail(string filePath)
		{
			//Console.WriteLine("C#: {0}", filePath);
			// Notify the system that the file has changed
			SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_PATHW, filePath, IntPtr.Zero);
		}
	}
"@
	
	foreach ($fileName in $args) {
		Write-Host $fileName
		[ThumbnailRefresh]::RefreshThumbnail($fileName)
	}
	
	
	
}
catch {
	Write-Host "An error occurred:"
	Write-Host $_
	pause
	exit
}
#pause