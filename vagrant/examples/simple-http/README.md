# Simple HTTP Vagrant Example

This is a basic Vagrant example that sets up a simple Ubuntu virtual machine with nginx.

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads) installed
- **For Linux/Windows:** [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed
- **For macOS (especially ARM/Apple Silicon):** [QEMU](https://www.qemu.org/) and the Vagrant QEMU plugin installed
  ```bash
  # Install QEMU (via Homebrew)
  brew install qemu
  
  # Install Vagrant QEMU plugin
  vagrant plugin install vagrant-qemu
  ```

## Usage

1. Navigate to this directory:
   ```bash
   cd vagrant/examples/simple-http
   ```

2. Start the virtual machine:
   ```bash
   # On macOS, explicitly specify QEMU provider:
   vagrant up --provider=qemu
   
   # Or set environment variable first:
   export VAGRANT_DEFAULT_PROVIDER=qemu
   vagrant up
   
   # On Linux/Windows with VirtualBox:
   vagrant up
   ```

3. SSH into the VM:
   ```bash
   vagrant ssh
   ```

4. Access nginx (running on guest port 80):
   ```bash
   curl http://localhost:8080
   ```
   Or open http://localhost:8080 in your browser

5. Stop the VM:
   ```bash
   vagrant halt
   ```

6. Destroy the VM:
   ```bash
   vagrant destroy
   ```

## What this example does

- Uses Ubuntu 18.04 (generic/ubuntu1804) as the base box
- On macOS: Uses QEMU provider with x86_64 architecture emulation
- On Linux/Windows: Uses VirtualBox provider
- Installs and starts nginx during provisioning
- Nginx serves on port 80 (guest), accessible via port 8080 (host)

