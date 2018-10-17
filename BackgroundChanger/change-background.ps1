# Add system libraries
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

# Sleep random time before running
#Sleep (Get-Random -Minimum (5*60) -Maximum (60*60))

# Wait for internet connection
while (-Not (Test-Connection -ComputerName github.com -Quiet -Count 1)) 
{
	sleep 3;
}


# Define base dir
$baseDir = "$env:temp\OneDrive"
# Make sure $baseDir exists
If(-Not(Test-Path $baseDir))
{
	New-Item -ItemType directory -Path $baseDir
}

# Download function
function downloadFile($url, $targetFile)
{ 
    "Downloading $url" 
    $uri = New-Object "System.Uri" "$url" 
    $request = [System.Net.HttpWebRequest]::Create($uri) 
    $request.set_Timeout(15000) #15 second timeout 
    $response = $request.GetResponse() 
    $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024) 
    $responseStream = $response.GetResponseStream() 
    $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $targetFile, Create 
    $buffer = new-object byte[] 10KB 
    $count = $responseStream.Read($buffer,0,$buffer.length) 
    $downloadedBytes = $count 
    while ($count -gt 0) 
    { 
        [System.Console]::CursorLeft = 0 
        [System.Console]::Write("Downloaded {0}K of {1}K", [System.Math]::Floor($downloadedBytes/1024), $totalLength) 
        $targetStream.Write($buffer, 0, $count) 
        $count = $responseStream.Read($buffer,0,$buffer.length) 
        $downloadedBytes = $downloadedBytes + $count 
    } 
    "`nFinished Download" 
    $targetStream.Flush()
    $targetStream.Close() 
    $targetStream.Dispose() 
    $responseStream.Dispose() 
}

# Url where the random pictures are downloaded from
$url = "https://picsum.photos/3840/2160?random"
$filename = "$baseDir\OneDrive.jpg"
# Set TLS 1.2 explicitly since POwershell uses 1.1 by default
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
downloadFile $url $filename

# Change background picture via setting registry keys
set-itemproperty -path "HKCU:Control Panel\Desktop" -name WallPaper -value $filename
# Update user settings
rundll32.exe user32.dll, UpdatePerUserSystemParameters ,1,True


$activeBackgroundBMP = "$baseDir\OneDrive.bmp"
# Load required assemblies and get object reference for System.Drawing.
$ret = [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");

# Setup definitions so we can use User32.dll's SystemParametersInfo's SPI_SETDESKWALLPAPER.
# We only want to add the type definition of "params" if the "params" class hasn't been previously created in this PS session.
if (-not ([System.Management.Automation.PSTypeName]'Params').Type) {
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Params
{
    [DllImport("User32.dll",CharSet=CharSet.Unicode)]
    public static extern int SystemParametersInfo (Int32 uAction,
                                                   Int32 uParam,
                                                   String lpvParam,
                                                   Int32 fuWinIni);
}
"@
}

# Setup some constants to be used with User32.dll's SystemParametersInfo.
$SPI_SETDESKWALLPAPER = 0x0014
$UpdateIniFile = 0x01
$SendChangeEvent = 0x02
$fWinIni = $UpdateIniFile -bor $SendChangeEvent


# If the target BMP doesn't exist, create a new one.
if (-Not (Test-Path $activeBackgroundBMP)) {

    # Create a new 1x1 bitmap, and save it.
    $ret = (new-object System.Drawing.Bitmap(1,1)).Save($activeBackgroundBMP,"BMP")
    Write-Host "New BMP created ($activeBackgroundBMP)."
}

$img = new-object System.Drawing.Bitmap($filename)
$img.Save($activeBackgroundBMP,"BMP")

# Dispose of the System.Drawing object, to release the $fileToCheck file (so it can be overwritten by other processes).
$img.Dispose()
$img = $null

# Refresh desktop background with the updated BMP image.
$ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $activeBackgroundBMP, $fWinIni)
