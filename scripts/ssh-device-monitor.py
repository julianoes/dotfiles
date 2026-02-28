#!/usr/bin/env python3
"""
SSH Device Monitor - Detects new devices with SSH on your LAN
"""

import socket
import ipaddress
import json
import os
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
import argparse

# File to store known devices
KNOWN_DEVICES_FILE = os.path.expanduser("~/.ssh_device_monitor.json")

def get_local_network():
    """Detect the local network range"""
    try:
        # Get the local IP address
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        
        # Assume /24 network (most common for home networks)
        network = ipaddress.IPv4Network(f"{local_ip}/24", strict=False)
        return network, local_ip
    except Exception as e:
        print(f"Error detecting network: {e}")
        return None, None

def check_ssh_port(ip, timeout=1):
    """Check if SSH port (22) is open on the given IP"""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((str(ip), 22))
        sock.close()
        return result == 0
    except:
        return False

def get_hostname(ip):
    """Try to get the hostname for an IP address"""
    try:
        hostname = socket.gethostbyaddr(str(ip))[0]
        return hostname
    except:
        return None

def scan_network(network, local_ip, max_workers=50):
    """Scan the network for devices with SSH open"""
    ssh_devices = {}
    total_hosts = network.num_addresses - 2  # Exclude network and broadcast
    
    print(f"Scanning network {network} for SSH devices...")
    print(f"Your IP: {local_ip}")
    print(f"Checking {total_hosts} possible hosts...\n")
    
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        # Submit all scan jobs
        future_to_ip = {
            executor.submit(check_ssh_port, ip): ip 
            for ip in network.hosts() if str(ip) != local_ip
        }
        
        completed = 0
        for future in as_completed(future_to_ip):
            ip = future_to_ip[future]
            completed += 1
            
            if completed % 50 == 0:
                print(f"Progress: {completed}/{total_hosts} hosts checked...")
            
            try:
                if future.result():
                    hostname = get_hostname(ip)
                    ssh_devices[str(ip)] = {
                        "hostname": hostname,
                        "first_seen": datetime.now().isoformat()
                    }
                    print(f"✓ Found SSH device: {ip}" + (f" ({hostname})" if hostname else ""))
            except Exception as e:
                pass
    
    print(f"\nScan complete! Found {len(ssh_devices)} SSH device(s).\n")
    return ssh_devices

def load_known_devices():
    """Load the list of known devices from file"""
    if os.path.exists(KNOWN_DEVICES_FILE):
        try:
            with open(KNOWN_DEVICES_FILE, 'r') as f:
                return json.load(f)
        except:
            return {}
    return {}

def save_known_devices(devices):
    """Save the list of known devices to file"""
    with open(KNOWN_DEVICES_FILE, 'w') as f:
        json.dump(devices, indent=2, fp=f)

def compare_devices(current_devices, known_devices):
    """Compare current scan with known devices and identify new ones"""
    new_devices = {}
    
    for ip, info in current_devices.items():
        if ip not in known_devices:
            new_devices[ip] = info
    
    return new_devices

def main():
    parser = argparse.ArgumentParser(
        description='Monitor your LAN for devices with SSH enabled',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                    # Scan and show new SSH devices
  %(prog)s --reset            # Clear known devices and rescan
  %(prog)s --list             # List all known SSH devices
  %(prog)s --network 192.168.1.0/24  # Scan specific network
        """
    )
    
    parser.add_argument('--reset', action='store_true',
                       help='Clear the known devices list and start fresh')
    parser.add_argument('--list', action='store_true',
                       help='List all known SSH devices')
    parser.add_argument('--network', type=str,
                       help='Specify network to scan (e.g., 192.168.1.0/24)')
    parser.add_argument('--timeout', type=float, default=1.0,
                       help='Connection timeout in seconds (default: 1.0)')
    parser.add_argument('--workers', type=int, default=50,
                       help='Number of parallel workers (default: 50)')
    
    args = parser.parse_args()
    
    # Handle --list option
    if args.list:
        known = load_known_devices()
        if not known:
            print("No known SSH devices.")
        else:
            print(f"Known SSH devices ({len(known)}):\n")
            for ip, info in sorted(known.items()):
                hostname = info.get('hostname', 'Unknown')
                first_seen = info.get('first_seen', 'Unknown')
                print(f"  {ip:15s} - {hostname:30s} (first seen: {first_seen})")
        return
    
    # Handle --reset option
    if args.reset:
        if os.path.exists(KNOWN_DEVICES_FILE):
            os.remove(KNOWN_DEVICES_FILE)
            print("Known devices list cleared.\n")
        else:
            print("No known devices to clear.\n")
    
    # Determine network to scan
    if args.network:
        try:
            network = ipaddress.IPv4Network(args.network, strict=False)
            local_ip = None
        except Exception as e:
            print(f"Error: Invalid network specification: {e}")
            return
    else:
        network, local_ip = get_local_network()
        if not network:
            print("Could not detect local network. Please specify with --network")
            return
    
    # Load known devices
    known_devices = load_known_devices()
    
    # Scan the network
    current_devices = scan_network(network, local_ip, max_workers=args.workers)
    
    # Find new devices
    new_devices = compare_devices(current_devices, known_devices)
    
    # Display results
    if new_devices:
        print("=" * 70)
        print(f"🚨 NEW SSH DEVICES DETECTED ({len(new_devices)}):")
        print("=" * 70)
        for ip, info in sorted(new_devices.items()):
            hostname = info.get('hostname', 'Unknown hostname')
            print(f"\n  IP:       {ip}")
            print(f"  Hostname: {hostname}")
            print(f"  Detected: {info['first_seen']}")
        print("\n" + "=" * 70)
    else:
        print("No new SSH devices detected.")
    
    # Update and save known devices
    known_devices.update(current_devices)
    save_known_devices(known_devices)
    
    print(f"\nTotal known SSH devices: {len(known_devices)}")
    print(f"Device list saved to: {KNOWN_DEVICES_FILE}")

if __name__ == "__main__":
    main()
