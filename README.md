# ReconX - Automated Reconnaissance Toolkit
  
*A powerful, automated reconnaissance tool for ethical hackers and penetration testers.*

## 🚀 Introduction
ReconX is an all-in-one reconnaissance tool designed to automate the essential steps of information gathering, including:
- **Subdomain enumeration**
- **Live host detection**
- **Fuzzing for hidden directories and files**
- **Port scanning with Nmap**
- **WAF (Web Application Firewall) detection**
- **SQL Injection vulnerability scanning**

Built for penetration testers, bug bounty hunters, and security researchers, ReconX streamlines recon tasks and saves time by integrating multiple tools into a single workflow.

---

## 🛠️ Installation
To install and use ReconX, follow these steps:

### Prerequisites:
Ensure you have the following dependencies installed:
```bash
sudo apt update && sudo apt install -y subfinder httpx ffuf nmap wafw00f sqlmap
```
--- 
## 📌 Usage
To run ReconX, use the following syntax:
```
./reconx.sh -d <domain> -o <output_dir> [options]
```
Options:
| Option        | Description                                    |
|--------------|--------------------------------|
| `-d <domain>` | Target domain for reconnaissance |
| `-o <output_dir>` | Directory to save the results |
| `-n` | Run Nmap for port scanning |
| `-s` | Run SQLMap for SQL injection testing |
| `-w` | Run WAF detection with wafw00f |
| `-f <fuzzer>` | Specify fuzzer (`ffuf`, `dirsearch`) |
| `-p` | Skip HTTPx scanning |
| `-q` | Skip fuzzing |
| `-h` | Display help and usage information |

Example:
```
./reconx.sh -d example.com -o output -n -s -w -f ffuf
```
---
## 🔥 Features 
- **Automated subdomain enumeration** using Subfinder.
- **Live host detection** via HTTPx.
- **Directory and file fuzzing** with FFUF.
- **Port scanning** using Nmap.
- **SQL injection vulnerability testing** via SQLMap.
- **Web Application Firewall (WAF) detection** with WafW00f.
- **Customizable options** for flexible scanning.

---
## ⚠️ Disclaimer
```
This tool is intended for educational and ethical testing purposes only. Unauthorized use on targets without explicit permission is **illegal** and punishable by law.
```
---
## 🤝 Contributing
```
Contributions are welcome! Feel free to fork the repository and submit a pull request.
```
