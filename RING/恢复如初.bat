@echo off
%1 %2
ver|find "5.">nul&&goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin
cd C:\RING
schtasks /delete /TN  "\TASK-RING\OnClass" /F
schtasks /delete /TN  "\TASK-RING\OffClass" /F
devcon disable *VAC*
pause
devcon reboot