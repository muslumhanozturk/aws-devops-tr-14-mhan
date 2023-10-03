# Hands-on Ansible-06: Manage Windows Servers with Ansible

The purpose of this hands-on training is to give students the knowledge of how to manage Windows machines with Ansible.

## Learning Outcomes

At the end of this hands-on training, students will be able to;

- Explain what are the requirments to connect to Windows nodes.

- What are the differences between managing linux nodes and windows nodes.

- Explain how to manage windows nodes.


## Outline

- Part 1 - Build the Infrastructure

- Part 2 - Configure Windows Nodes

- Part 3 - Install Ansible on the Controller Node

- Part 3 - Pinging the Target Nodes 

- Part 4 - Managing the Windows nodes.


## Part 1 - Build the Infrastructure

- Get to the AWS Console and spin-up 3 EC2 Instances (with two ```Amazon Linux 2``` and one ```Microsoft Windows Server 2019 Base``` AMI.)

- Configure the security groups as shown below:

    - Control-Node (Amazon Linux 2) --> Port 22 (SSH), 5986 (winrm for HTTPS)

    - Target-Node1 (Linux) -------> Port 22 (SSH)

    - Target-Node2 (Windows) -------> Port 3389 (RDP), 5986 (winrm for HTTPS) 


## Part 2 - Configure Windows Node

- For Ansible to communicate to a Windows host and use Windows modules, the Windows host must meet these requirements:

  - Ansible can generally manage Windows versions under current and extended support from Microsoft. Ansible can manage desktop OSs including Windows 7, 8.1, and 10, and server OSs including Windows Server 2008, 2008 R2, 2012, 2012 R2, 2016, and 2019.

  - Ansible requires PowerShell 3.0 or newer and at least .NET 4.0 to be installed on the Windows host. 

  - A WinRM listener should be created and activated. 

- Connect to your ```Windows Node``` via remote desktop client.

- Check the PowerShell Version.

```powershell
$PSVersionTable
```

- Check the version of .NET installed.


```powershell
Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name version -EA 0 | Where { $_.PSChildName -Match '^(?!S)\p{L}'} | Select PSChildName, version
```

- To view the current listeners that are running on the WinRM service, run the following command:

```powershell
winrm enumerate winrm/config/Listener
```

- Note: If you do not see the information of the listeners, run following script in PowerShell to configure listener and service for the WinRM. (This script script sets up both HTTP and HTTPS listeners with a self-signed certificate and enables the Basic authentication option on the service.)

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)

powershell.exe -ExecutionPolicy ByPass -File $file
```


## Part 3 - Install and configure Ansible on the Controller Node

- Connect to your ```Controller Node```.

- Optionally you can connect to your instances using VS Code.

                    -------------------- OPTIONAL BELOW ----------------------

- You can also use connect to the Controller Node via VS Code's ```Remote SSH``` Extension. 

- Open up your VS Code editor. 

- Click on the ```Extensions``` icon. 

- Write down ```Remote - SSH``` on the search bar. 

- Click on the first option on the list.

- Click on the install button.

- When the extension is installed, restart your editor.

- Click on the green button (```Open a Remote Window``` button) at the most bottom left.

- Hit enter. (```Connect Current Window to Host...```)

- Enter a name for your connection on the input field and click on ```Add New SSH Host``` option.

- Enter your ssh connection command (```ssh -i <YOUR-PEM-FILE> ec2-user@<YOUR SERVER IP>```) on the input field and hit enter.

- Hit enter again.

- Click on the ```connect``` button at the bottom right.

- Click on ```continue``` option.

- Click on the ```Open Folder``` button and then click on the ```Ok``` button.

- Lastly, open up a new terminal on the current window.

                    -------------------- OPTIONAL ABOVE ----------------------

- Run the commands below to install Ansible. 

```bash
sudo hostnamectl set-hostname control-node
sudo yum update -y
pip3 install --user ansible
```

- Check Ansible's installation with the command below.

```bash
ansible --version
```

- Run the command below to transfer your pem key to your Ansible Controller Node.

```bash
$ scp -i <PATH-TO-PEM-FILE> <PATH-TO-PEM-FILE> ec2-user@<CONTROLLER-NODE-IP>:/home/ec2-user
```
```bash
sudo chmod 400 tyler-team.pem
```

- Install ```pywinrm``` package.

  WinRM is a management protocol used by Windows to remotely communicate with another server. It is a SOAP-based protocol that communicates over HTTP/HTTPS, and is included in all recent Windows operating systems. Since Windows Server 2012, WinRM has been enabled by default, but in most cases extra configuration is required to use WinRM with Ansible.

  Ansible uses the pywinrm package to communicate with Windows servers over WinRM. It is not installed by default with the Ansible package, but can be installed by running the following:

```bash
pip3 install "pywinrm>=0.3.0" --user
```

https://github.com/diyan/pywinrm



## Part 3 - Pinging the Linux Node.


- Create a directory named ```project-1``` under the home directory and cd into it.

```bash 
mkdir project-1
cd project-1
```

- Create a file named ```inventory.txt``` with the command below.

```bash
vi inventory.txt
```

- Paste the content below into the inventory.txt file.

- Along with the hands-on, public or private IPs can be used.

```txt
[linux_servers]
Node-1  ansible_host=<YOUR-WEB-SERVER-IP>  ansible_user=ec2-user  ansible_ssh_private_key_file=~/<YOUR-PEM-FILE>
```
- Create file named ```ansible.cfg``` under the the ```project-1``` directory.

```cfg
[defaults]
# host_key_checking = False
inventory=inventory.txt
# interpreter_python=auto_silent
# deprecation_warnings=False
```

- Run the command below for pinging the linux server.

```bash
ansible linux_servers -m ping
```

- Explain the output of the above command.


## Part 4 - Pinging the Windows Node

- Copy the ```project-1```directory as a ```project-2```directory under the home directory and cd into it.

```bash
cd ..
cp -r ~/project-1/ ~/project-2/
cd project-2
```

- Create a file named ```inventory.ini``` under the  ```project-2```directory with the command below.

```bash
vi inventory.ini
```
- Paste the content below into the inventory.txt file.

```ini
[windows_servers]
node-2 ansible_host=18.188.118.42

[all:vars]
ansible_user= Administrator
ansible_password= U.@65W)szlA5DrVF*;HyuGy5J8$M%3Wh
ansible_connection= winrm
ansible_winrm_server_cert_validation= ignore
```

- Create a file named ```ping.yml``` under the  ```project-2```directory with the command below.

```bash
vi ping.yml
```
- Paste the content below into the ping.yml file.

```yaml
- name: ping
  hosts: windows_servers
  tasks:  
    - name: Check the connectivity for windows server
      win_ping:
```

- Run the ping.yml playbook

```bash
ansible-playbook ping.yml -i inventory.ini
```

## Part 5 - Pinging all Nodes.

- Copy the ```project-2```directory as a ```project-3```directory under the home directory and cd into it.

```bash
cd ..
cp -r project-2/ project-3/
cd project-3
```

- Delete ```inventory.txt``` and ```inventory.ini``` files.

```bash
rm inventory.txt inventory.ini
```

- Create a file named ```inventory.yml``` under the  ```project-3```directory with the command below.

```bash
vi inventory.yml
```

```yaml
windows_servers:
  hosts:
    18.188.118.42

  vars:
    ansible_connection: winrm
    ansible_winrm_server_cert_validation: ignore
    ansible_user: Administrator
    ansible_password: 3j6zz;-C)AfzCyvLoW%L6)S&WawzPoYw

linux_servers:
  hosts:
    3.144.191.123

  vars:
    ansible_ssh_private_key_file: ~/tyler-team.pem
    ansible_user: ec2-user
```

- Modify the ansible.cfg file with the following line.

```yaml
inventory=inventory.yml
```

- Modify the ping.yml file with the following playbook.

```yml
- name: ping
  hosts: windows_servers
  tasks:  
    - name: Check the connectivity for windows server
      win_ping:

- name: ping
  hosts: linux_servers
  tasks:  
    - name: Check the connectivity for Linux server
      ping:
```

- Run the ping.yml playbook.

```bash
ansible-playbook ping.yml
```


## Part 6 - Configure Windows Servers.

- Copy the ```project-3```directory as a ```project-4```directory under the home directory and cd into it.

```bash
cd ..
cp -r project-3/ project-4/
cd project-4
```

- Create a playbook named ```configure-windows.yml``` under the  ```project-4```directory with the command below.

```bash
vi configure-windows.yml
```

- Paste the content below into the configure-windows.yml file.

```yaml
- name: windows server configuration
  hosts: windows_servers
  tasks:  
    - name: Set timezone to 'Romance Standard Time' (GMT+01:00)
      win_timezone:
        timezone: Romance Standard Time

    - name: Change the hostname to webserver-2
      win_hostname:
        name: windows-hostname
      register: res

    - name: Reboot
      win_reboot:
      when: res.reboot_required
```

- Run the configure-windows.yml playbook.

```bash
ansible-playbook configure-windows.yml
```

## Part 7 - Use group_vars and Vault for Secrets.

- Copy the ```project-4```directory as a ```project-5``` directory under the home directory and cd into it.

```bash
cd ..
cp -r project-4/ project-5/
cd project-5
```

- Create ```group_vars``` directory under the project-5 folder and cd into it.

```bash
mkdir group_vars
cd group_vars
```

- Create an encypted file using "ansible-vault" command named ```windows_servers.yml``` under the group_vars directory.

```bash
ansible-vault create windows_servers.yml
```

New Vault password: xxxx
Confirm Nev Vault password: xxxx

```yml
ansible_user: Administrator
ansible_password: 3j6zz;-C)AfzCyvLoW%L6)S&WawzPoYw
```

- Modify the ```configure-windows.yml``` file with the following line.

```yml
      win_timezone:
        timezone: Central Standard Time
------
      win_hostname:
        name: tyler-hostname
```
- Comment out ```ansible_user``` and ```ansible_password``` lines from inventory.yml file.

- Run the playbook.

```bash
ansible-playbook configure-windows.yml --ask-vault-pass
```

## Part 8 - Install softwares with win_chocolatey module. 

- Copy the ```project-5```directory as a ```project-6``` directory under the home directory and cd into it.

```bash
cd ..
cp -r project-5/ project-6/
cd project-6
```
- Modify the ```configure-windows.yml``` file with following:

```yml
- name: win_chocolatey module example
  hosts: windows_servers
  gather_facts: false
  vars:
    - packages:
      - git
      - sublimetext4
      - notepadplusplus
      - googlechrome
      - docker-desktop
  tasks:
    - name: install packages
      win_chocolatey:
        name: "{{ packages }}"
        state: present
```

- Run the playbook.

```bash
ansible-playbook configure-windows.yml --ask-vault-pass
```

## Part 9 -  Using DSC module.

- Copy the ```project-6```directory as a ```project-7``` directory under the home directory and cd into it.

```bash
cd ..
cp -r project-6/ project-7/
cd project-7
```

- Modify the ```configure-windows.yml``` file with following:

```yml
- name: DSC module example
  hosts: windows_servers
  gather_facts: false
  tasks:
  - name: Create file with some text
    win_dsc:
      resource_name: File
      DestinationPath: C:\temp\file
      Contents: |
          Hello
          World
      Ensure: Present
      Type: File
```


- create a file named  ```open_vault.txt``` and type your ```vault password```in it.

```bash
vi open_vault.txt
```

- Add the following line into the ```ansible.cfg``` file.

```cfg
vault_password_file= open_vault.txt
```

- Run the playbook.

```bash
ansible-playbook configure-windows.yml
```
------------------------------











