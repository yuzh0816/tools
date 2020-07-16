@echo off
echo "The batch file will use the administrative privilege"
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
set /p ip=Please enter the IP address
set /p host=Please enter the domain
ECHO ^ip host>>%WINDIR%\system32\drivers\etc\hosts
