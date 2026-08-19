#!/usr/bin/bash
#
# This script, if present in your vpodrepo root, is run at the end of labsartup.
# It is called during the "final.py"
# Here's the overall flow:
# prelim.py -> ESXi.py -> VCF.py -> VVF.py -> vSphere.py -> pings.py -> services.py -> Kubernetes.py -> urls.py -> VCFfinal.py -> final.py -> odyssey.py 
#
# If you prefer scripting in Python:
# You may optionally place a "lab-update.py" in this folder and it would be called immediately folling the call of this lab-update.sh script
# 
# Source the .bashrc file for settings/paths/etc...
. /home/holuser/.bashrc
# Insert your custom code here:
# the root password on dsm-01a and dsm-01b were set to never. This generates an Global Alert in the DSM Dashboard. 
# We can check to see if the pw is still set to never and if so, set it to 9999:
dsm_01b_root_expires=$(sshpass -f /home/holuser/creds.txt ssh -q -o StrictHostKeyChecking=accept-new root@dsm-01b.site-b.vcf.lab "chage -l root" 2>/dev/null | awk -F':' '/Password expires/ {print $2}' | xargs)

if [ "${dsm_01b_root_expires}" == "never" ]; then
    sshpass -f /home/holuser/creds.txt ssh -q -o StrictHostKeyChecking=accept-new root@dsm-01b.site-b.vcf.lab "chage -M 9999 root" 2>/dev/null
fi

dsm_01a_root_expires=$(sshpass -f /home/holuser/creds.txt ssh -q -o StrictHostKeyChecking=accept-new root@dsm-01a.site-a.vcf.lab "chage -l root" 2>/dev/null | awk -F':' '/Password expires/ {print $2}' | xargs)

if [ "${dsm_01a_root_expires}" == "never" ]; then
    sshpass -f /home/holuser/creds.txt ssh -q -o StrictHostKeyChecking=accept-new root@dsm-01a.site-a.vcf.lab "chage -M 9999 root" 2>/dev/null
fi

# Example to echo text into file on Console VM. 
# NOTE: when this script runs, /lmchol is mounted to the "/" of the Console VM
# echo "Functional Testing!" > /lmchol/home/holuser/Documents/FT.txt