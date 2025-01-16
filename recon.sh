#!/bin/bash

# Default settings
SUBDOMAIN_DISCOVERY="subfinder"
HTTPX="httpx-toolkit"
FUZZER="ffuf"
PORTSCAN="nmap"
WAF_SCAN="wafw00f"
SQLMAP="sqlmap"
WORDLIST="<- Your WordList Location ->"
LIVE_SUBDOMAINS=""
DOMAIN=""
OUTPUT_DIR=""
NMAP_SCAN="false"
SQLMAP_SCAN="false"
WAF_SCAN_FLAG="false"
SKIP_HTTPX="false"
SKIP_FUZZING="false"

# Function to display usage
usage() {
    echo "

███████████████████████████████████████████████████████████████████████████████████████████████████████████
█░░░░░░░░░░░░░░░░███░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█░░░░░░██████████░░░░░░█░░░░░░░░██░░░░░░░░█
█░░▄▀▄▀▄▀▄▀▄▀▄▀░░███░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░░░░░░░░░██░░▄▀░░█░░▄▀▄▀░░██░░▄▀▄▀░░█
█░░▄▀░░░░░░░░▄▀░░███░░▄▀░░░░░░░░░░█░░▄▀░░░░░░░░░░█░░▄▀░░░░░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░██░░▄▀░░█░░░░▄▀░░██░░▄▀░░░░█
█░░▄▀░░████░░▄▀░░███░░▄▀░░█████████░░▄▀░░█████████░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░██░░▄▀░░███░░▄▀▄▀░░▄▀▄▀░░███
█░░▄▀░░░░░░░░▄▀░░███░░▄▀░░░░░░░░░░█░░▄▀░░█████████░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░██░░▄▀░░███░░░░▄▀▄▀▄▀░░░░███
█░░▄▀▄▀▄▀▄▀▄▀▄▀░░███░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░█████████░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░██░░▄▀░░█████░░▄▀▄▀▄▀░░█████
█░░▄▀░░░░░░▄▀░░░░███░░▄▀░░░░░░░░░░█░░▄▀░░█████████░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░██░░▄▀░░███░░░░▄▀▄▀▄▀░░░░███
█░░▄▀░░██░░▄▀░░█████░░▄▀░░█████████░░▄▀░░█████████░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░░░░░▄▀░░███░░▄▀▄▀░░▄▀▄▀░░███
█░░▄▀░░██░░▄▀░░░░░░█░░▄▀░░░░░░░░░░█░░▄▀░░░░░░░░░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░▄▀▄▀▄▀▄▀▄▀░░█░░░░▄▀░░██░░▄▀░░░░█
█░░▄▀░░██░░▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░░░░░░░░░▄▀░░█░░▄▀▄▀░░██░░▄▀▄▀░░█
█░░░░░░██░░░░░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█░░░░░░██████████░░░░░░█░░░░░░░░██░░░░░░░░█
███████████████████████████████████████████████████████████████████████████████████████████████████████████
"
    echo "Usage: $0 -d <domain> -o <output_dir> [-n] [-s] [-w] [-f <fuzzer>] [-p] [-q] [-h]"
    echo ""
    echo "Recon Script to automate subdomain discovery, HTTP probing, fuzzing, port scanning, WAF detection, and SQL injection testing."
    echo ""
    echo "  -d <domain>          Domain to perform recon on."
    echo "  -o <output_dir>      Directory to save the results."
    echo "  -n                   Run Nmap for port scanning."
    echo "  -s                   Run SQLMap for SQL injection testing."
    echo "  -w                   Run WAF detection with wafw00f."
    echo "  -f <fuzzer>          Fuzzer to use (ffuf, dirsearch). Default is ffuf."
    echo "  -p                   Skip HTTPX scanning (if you already have live subdomains)."
    echo "  -q                   Skip fuzzing (if you don't want fuzzing)."
    echo "  -h                   Display this help and exit."
    echo ""
    echo "Example:"
    echo "  ./recon.sh -d example.com -o /path/to/output -n -s -w -f ffuf"
    echo "    This will run all options including subdomain discovery, HTTP probing, fuzzing, Nmap scan, SQLMap, and WAF detection."
    echo ""
    exit 0
}

# Parse command line options
while getopts "d:o:nswpf:qh" opt; do
    case "$opt" in
        d) DOMAIN=$OPTARG ;;
        o) OUTPUT_DIR=$OPTARG ;;
        n) NMAP_SCAN="true" ;;
        s) SQLMAP_SCAN="true" ;;
        w) WAF_SCAN_FLAG="true" ;;
        f) FUZZER=$OPTARG ;;
        p) SKIP_HTTPX="true" ;;
        q) SKIP_FUZZING="true" ;;
        h) usage ;;
        *) usage ;;
    esac
done

# Ensure DOMAIN and OUTPUT_DIR are provided
if [ -z "$DOMAIN" ] || [ -z "$OUTPUT_DIR" ]; then
    usage
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/subdomains"
mkdir -p "$OUTPUT_DIR/httpx"
mkdir -p "$OUTPUT_DIR/fuzzing"
mkdir -p "$OUTPUT_DIR/nmap"
mkdir -p "$OUTPUT_DIR/waf"

echo  "

"
echo "[*] Starting recon for $DOMAIN"

# 1. Subdomain Discovery
echo "[*] Running subdomain discovery with $SUBDOMAIN_DISCOVERY"
$SUBDOMAIN_DISCOVERY -d $DOMAIN -o "$OUTPUT_DIR/subdomains/subdomains.txt"

# 2. HTTPx to check live subdomains (if HTTPX is not skipped)
if [ "$SKIP_HTTPX" != "true" ]; then
    echo "[*] Checking live subdomains with $HTTPX"
    cat "$OUTPUT_DIR/subdomains/subdomains.txt" | $HTTPX -silent -o "$OUTPUT_DIR/httpx/live_subdomains.txt"
    LIVE_SUBDOMAINS="$OUTPUT_DIR/httpx/live_subdomains.txt"
else
    echo "[*] Skipping HTTPX. Please ensure you already have live subdomains in $LIVE_SUBDOMAINS."
    LIVE_SUBDOMAINS="$OUTPUT_DIR/subdomains/subdomains.txt"
fi

# 3. Fuzzing (if not skipped)
if [ "$SKIP_FUZZING" != "true" ]; then
    echo "[*] Starting fuzzing with $FUZZER"
    while read -r subdomain; do
        $FUZZER -u "http://$subdomain/FUZZ" -w $WORDLIST -o "$OUTPUT_DIR/fuzzing/$subdomain_fuzz.txt"
    done < "$LIVE_SUBDOMAINS"
else
    echo "[*] Skipping fuzzing."
fi

# 4. Port Scanning (if enabled)
if [ "$NMAP_SCAN" == "true" ]; then
    echo "[*] Running Nmap for port scanning"
    while read -r subdomain; do
        $PORTSCAN -p- -T4 -oN "$OUTPUT_DIR/nmap/$subdomain-nmap.txt" "$subdomain"
    done < "$LIVE_SUBDOMAINS"
else
    echo "[*] Skipping Nmap port scanning."
fi

# 5. SQL Injection Testing (if enabled)
if [ "$SQLMAP_SCAN" == "true" ]; then
    echo "[*] Running SQLMap for SQL injection testing"
    while read -r subdomain; do
        $SQLMAP -u "http://$subdomain" --batch --output-dir="$OUTPUT_DIR/sqlmap" --threads=10
    done < "$LIVE_SUBDOMAINS"
else
    echo "[*] Skipping SQLMap testing."
fi

# 6. WAF Detection (if enabled)
if [ "$WAF_SCAN_FLAG" == "true" ]; then
    echo "[*] Running WAF detection with $WAF_SCAN"
    while read -r subdomain; do
        $WAF_SCAN "$subdomain" >> "$OUTPUT_DIR/waf/$subdomain_waf.txt"
    done < "$LIVE_SUBDOMAINS"
else
    echo "[*] Skipping WAF detection."
fi

echo "[*] Recon process completed."

