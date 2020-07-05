# 1clinux
Some configs and scripts for tune postgres for 1C

pg: 10! pgstrom: 2.3!

Configs place in:
DEB: /etc/init.d/srv1cv83
RPM: /etc/sysconfig/srv1cv83




Ensure VT-d is supported and enabled in the BIOS
Enable IOMMU on the host
append the following to the GRUB_CMDLINE_LINUX_DEFAULT line in /etc/default/grub
intel_iommu=on
Save your changes by running
update-grub
Blacklist NVIDIA & Nouveau kernel modules so they don’t get loaded at boot
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia" >> /etc/modprobe.d/blacklist.conf
Save your changes by running
update-initramfs -u
Add the following lines to /etc/modules
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
Determine the PCI address of your GPU
Run
lspci -v
and look for your card. Mine was 01:00.0 & 01:00.1. You can omit the part after the decimal to include them both in one go – so in that case it would be 01:00

Run lspci -n -s <PCI address> to obtain vendor IDs. Example :
lspci -n -s 01:00
01:00.0 0300: 10de:1b81 (rev a1)
01:00.1 0403: 10de:10f0 (rev a1)
Assign your GPU to vfio driver using the IDs obtained above. Example:
echo "options vfio-pci ids=10de:1b81,10de:10f0" > /etc/modprobe.d/vfio.conf
Reboot the host
Create your Windows VM using the UEFI bios hardware option (not the deafoult seabios) but do not start it yet. Modify /etc/pve/qemu-server/<vmid>.conf and ensure the following are in the file. Create / modify existing entries as necessary.
bios: ovmf
machine: q35
cpu: host,hidden=1
numa: 1
Install Windows, including VirtIO drivers. Be sure to enable Remote desktop.
Pass through the GPU.
Modify /etc/pve/qemu-server/<vmid>.conf and add
hostpci0: <device address>,x-vga=on,pcie=1. Example
hostpci0: 01:00,x-vga=on,pcie=1
Profit.
