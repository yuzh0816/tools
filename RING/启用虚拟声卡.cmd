@echo off
chcp 65001
%1 %2
ver|find "5.">nul&&goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin
cd C:\RING
devcon enable *VAC*
nircmd setdefaultsounddevice "CABLE Input"
nircmd setdefaultsounddevice "CABLE Output"
echo 声卡已切换至虚拟声卡，按任意键即会重启。
pause
devcon reboot