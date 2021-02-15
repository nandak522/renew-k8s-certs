#!/bin/bash

# Usage: ./create_virtualbox_ubuntu_vm Ubuntu-Server-<id> <Iso fullpath>

set -eou pipefail

MACHINENAME=$1
ISO=$2

#Create VM
VBoxManage createvm --name ${MACHINENAME} --ostype Ubuntu_64 --register --basefolder /Users/nanda/VirtualBoxVMs
#Set memory and network
VBoxManage modifyvm ${MACHINENAME} --ioapic on
VBoxManage modifyvm ${MACHINENAME} --graphicscontroller vmsvga --cpus 2 --memory 2048 --vram 256
VBoxManage modifyvm ${MACHINENAME} --nic1 bridged --nictype1 82540EM --bridgeadapter1 'en0: Wi-Fi (AirPort)'

#Create Disk and connect Debian Iso
VBoxManage createhd --filename /Users/nanda/VirtualBoxVMs/${MACHINENAME}/${MACHINENAME}_DISK.vdi --size 30000 --format VDI
VBoxManage storagectl ${MACHINENAME} --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach ${MACHINENAME} --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /Users/nanda/VirtualBoxVMs/${MACHINENAME}/${MACHINENAME}_DISK.vdi
VBoxManage storagectl ${MACHINENAME} --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach ${MACHINENAME} --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $ISO
VBoxManage modifyvm ${MACHINENAME} --boot1 dvd --boot2 disk --boot3 none --boot4 none

#Enable RDP
#VBoxManage modifyvm ${MACHINENAME} --vrde on
#VBoxManage modifyvm ${MACHINENAME} --vrdemulticon on --vrdeport 10001

#Start the VM
VBoxHeadless --startvm ${MACHINENAME} &
