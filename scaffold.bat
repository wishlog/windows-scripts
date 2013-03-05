::Author: Scott Tse
::Email: wishlog@gmail.com
::Create: July 2011
::
::This simple script was created for scaffolding / housekeeping of different clients after the project kickstarted. 
::It also help to finish the discovery phase with a set of well known port numbers and generate an html report and visible with zenmap.
::This script was already abandoned as likely no one still use Windows as a testing machine… 
::In order to run the script, you have to:
::1. Install nmap and nmap\xml2html\xsltproc.exe in the same directory with the script.
::2. Find any nmap parser and put it under Parser\nmap_parse.pl
::3. Install Active Perl if no Perl environment.

@echo off
cls

echo 
Echo Running net stop sharedaccess
net stop sharedaccess
pause
cls

for /f "tokens=2-4 delims=/ " %%a in ('date /T') do set year=%%c
for /f "tokens=2-4 delims=/ " %%a in ('date /T') do set month=%%a
for /f "tokens=2-4 delims=/ " %%a in ('date /T') do set day=%%b
set TODAY=%year%-%month%-%day%



IF NOT EXIST Clients mkdir Clients
:Client
set Client=
set /P Client=Enter your client name [Google]: %=%
if "%Client%"=="" goto ERROR
IF NOT EXIST Clients\%Client% (
	mkdir Clients\%Client%
	ECHO 'The new client %Client% is created'
	pause
	ECHO 'Enter IP address here' > Clients\%Client%\ip.txt
	Clients\%Client%\ip.txt
)


Echo "File list:"
dir Clients\%Client%
:IP_range
set IP_range=
set /P IP_range=Enter your IP range [ip.txt]: %=%
if "%IP_range%"=="" goto IP_range
if NOT EXIST Clients\%Client%\%IP_range% (
cls
Echo "File list:"
dir Clients\%Client%
ECHO Cannot found Clients\%Client%\%IP_range% 
ECHO Please specify complete name, e.g. google.txt
goto IP_range
)


:Target
set Target=
set /P Target=Enter your target name [host_to_management]: %=%


:scantype
set scantype=
set /P scantype=Scanning type [f for fast, c for complete, n for devil, others for error]: %=%


echo Start scanning for: Clients\%Client%\%IP_range% 
title %Client% Scanning in progress




IF NOT EXIST Clients\%Client%\results mkdir Clients\%Client%\results
IF NOT EXIST Clients\%Client%\results\raw mkdir Clients\%Client%\results\raw

nmap\nmap --script-updatedb
Echo "No ping test, Clients\%Client%\results\raw\nmap_%IP_range%.xml Reverse DNS resolve, Default script, syn scan, probe port, xml out"

if "%scantype%"=="c" (
nmap\nmap -Pn -R -sC -sS -P0 -O -sV -v -oA Clients\%Client%\results\raw\%Target% -iL Clients\%Client%\%IP_range% --traceroute
)
if "%scantype%"=="f" (
nmap\nmap -PE --traceroute -oA Clients\%Client%\results\raw\%Target% -iL Clients\%Client%\%IP_range% --traceroute
)
if "%scantype%"=="n" (
nmap\nmap -sS -T3 -PP -PE -PM -PI -PA20,53,80,113,443,5060,10043 --host-timeout=10m -O --max-rtt-timeout=600ms --initial-rtt-timeout=300ms --min-rtt-timeout=300ms --max-retries=2 --stats-every 10s --traceroute -PS1,7,9,13,21-23,25,37,42,49,53,69,79-81,105,109-111,113,123,135,137-139,143,161,179,222,384,389,407,443,445,465,500,512-515,523,540,548,554,587,617,623,689,705,783,910,912,921,993,995,1000,1024,1100,1158,1220,1300,1311,1352,1433-1435,1494,1521,1530,1533,1581-1582,1604,1720,1723,1755,1900,2000,2049,2100,2103,2121,2207,2222,2323,2380,2525,2533,2598,2638,2947,2967,3000,3050,3057,3128,3306,3389,3500,3628,3632,3690,3780,3790,4000,4445,5051,5060-5061,5093,5168,5250,5353,5400,5405,5432-5433,5554-5555,5560,5800,5900-5910,6000,6050,6060,6070,6080,6101,6106,6112,6405,6502-6504,6660,6667,7080,7144,7210,7510,7777,7787,8000,8008,8028,8030,8080-8081,8090,8180,8222,8300,8333,8400,8443-8444,8800,8812,8880,8888,8899,9080-9081,9090,9111,9152,9999-10001,10050,10202-10203,10443,10616,10628,11000,12174,12203,12397,13500,14330,17185,18881,19300,19810,20031,20222,22222,25000,25025,26000,26122,28222,30000,38292,41025,41523-41524,44334,50000-50004,50013,57772,62078,62514,65535 --min-rate=150 -PU54696 -p1,7,9,13,21-23,25,37,42,49,53,69,79-81,105,109-111,113,123,135,137-139,143,161,179,222,384,389,407,443,445,465,500,512-515,523,540,548,554,587,617,623,689,705,783,910,912,921,993,995,1000,1024,1100,1158,1220,1300,1311,1352,1433-1435,1494,1521,1530,1533,1581-1582,1604,1720,1723,1755,1900,2000,2049,2100,2103,2121,2207,2222,2323,2380,2525,2533,2598,2638,2947,2967,3000,3050,3057,3128,3306,3389,3500,3628,3632,3690,3780,3790,4000,4445,5051,5060-5061,5093,5168,5250,5353,5400,5405,5432-5433,5554-5555,5560,5800,5900-5910,6000,6050,6060,6070,6080,6101,6106,6112,6405,6502-6504,6660,6667,7080,7144,7210,7510,7777,7787,8000,8008,8028,8030,8080-8081,8090,8180,8222,8300,8333,8400,8443-8444,8800,8812,8880,8888,8899,9080-9081,9090,9111,9152,9999-10001,10050,10202-10203,10443,10616,10628,11000,12174,12203,12397,13500,14330,17185,18881,19300,19810,20031,20222,22222,25000,25025,26000,26122,28222,30000,38292,41025,41523-41524,44334,50000-50004,50013,57772,62078,62514,65535 -oA Clients\%Client%\results\raw\%Target% -iL Clients\%Client%\%IP_range% --traceroute
)


echo 
echo 
nmap\xml2html\xsltproc.exe Clients\%Client%\results\raw\%Target%.xml > Clients\%Client%\results\raw\%Target%.html

Parser\nmap_parse.pl Clients\%Client%\results\raw\%Target%.nmap  > Clients\%Client%\results\%Target%.xls

Clients\%Client%\results\raw\%Target%.html

title Finished %Client% 

nmap\zenmap -f Clients\%Client%\results\raw\%Target%.xml 


GOTO END

:ERROR
cls
ECHO Ususage:
ECHO To scaffold google.com
ECHO 1. Create folder under Clients\google (Client name)
ECHO 2. Create IP files under Clients\google\IP.txt (IP range files)
ECHO Enjoy
ECHO.
GOTO Client
:END
