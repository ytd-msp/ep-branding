# --- CONFIGURATION ---
$WallpaperUrl = "https://www.yourtechdept.co.uk/uq8723HD481X/EPwallpaper1.jpg" # the location of the image
$LocalFolder = "$env:LOCALAPPDATA\CompanyBranding" # local storage location of downloaded wallpaper image
$FileName = "CompanyWallpaper.jpg" # name of image on the local computer
$LocalPath = Join-Path $LocalFolder $FileName

# --- EXECUTION ---
# 1. Ensure the local directory exists
if (-not (Test-Path $LocalFolder)) {
    New-Item -Path $LocalFolder -ItemType Directory -Force
}

# 2. Download the wallpaper from your website
Invoke-WebRequest -Uri $WallpaperUrl -OutFile $LocalPath

# 3. Set the wallpaper in the Registry
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name wallpaper -Value $LocalPath

# 4. Update the system to reflect the change immediately
# This sends a message to the OS to refresh the desktop without a reboot
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SetWallpaper(20, 0, $LocalPath, 0x01 -bor 0x02)
