@echo off

::Borrowed from @abbodi1406's scripts
for /f "tokens=6 delims=[]. " %%i in ('ver') do set build=%%i

if %build% LSS 17763 (
    echo =====================================
    echo 此脚本仅与 Windows 10 RS5 及更高版本兼容。
    echo =====================================
    echo.
    pause
    goto :EOF
)

REG QUERY HKU\S-1-5-19\Environment >NUL 2>&1
IF %ERRORLEVEL% EQU 0 goto :START_SCRIPT

echo =====================================
echo 此脚本需要以管理员身份执行。
echo =====================================
echo.
pause
goto :EOF

:START_SCRIPT
set "scriptver=2.5.0"
set "FlightSigningEnabled=0"
bcdedit /enum {current} | findstr /I /R /C:"^flightsigning *Yes$" >NUL 2>&1
IF %ERRORLEVEL% EQU 0 set "FlightSigningEnabled=1"

title Windows Insider 离线注册工具 v%scriptver%中文版

:CHOICE_MENU
cls
set "choice="
mode con cols=50 lines=20
echo Windows Insider 离线注册工具 v%scriptver%中文版
echo.
echo 1 - 注册 Dev 频道
echo 2 - 注册 Beta 频道
echo 3 - 注册 Release Preview 频道
echo.
echo 4 - 停止接收 Insider Preview 版本
echo 5 - 退出而不做任何更改
echo.
set /p choice="选择： "
echo.
if /I "%choice%"=="1" goto :ENROLL_DEV
if /I "%choice%"=="2" goto :ENROLL_BETA
if /I "%choice%"=="3" goto :ENROLL_RP
if /I "%choice%"=="4" goto :STOP_INSIDER
if /I "%choice%"=="5" goto :EOF
goto :CHOICE_MENU

:ENROLL_RP
set "Channel=ReleasePreview"
set "Fancy=Release Preview 频道"
set "BRL=8"
goto :ENROLL

:ENROLL_BETA
set "Channel=Beta"
set "Fancy=Beta 频道"
set "BRL=4"
goto :ENROLL

:ENROLL_DEV
set "Channel=Dev"
set "Fancy=Dev 通道"
set "BRL=2"
goto :ENROLL

:RESET_INSIDER_CONFIG
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Account" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Applicability" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Cache" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\WUMUDCat" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\RingExternal" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\RingPreview" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\RingInsiderSlow" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\RingInsiderFast" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v BranchReadinessLevel /f
goto :EOF

:ADD_INSIDER_CONFIG
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator" /t REG_DWORD /v EnableUUPScan /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\RingExternal" /t REG_DWORD /v Enabled /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\WUMUDCat" /t REG_DWORD /v WUMUDCATEnabled /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Applicability" /t REG_DWORD /v EnablePreviewBuilds /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Applicability" /t REG_DWORD /v IsBuildFlightingEnabled /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Applicability" /t REG_DWORD /v IsConfigSettingsFlightingEnabled /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Applicability" /t REG_DWORD /v TestFlags /d 32 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Applicability" /t REG_DWORD /v RingId /d 11 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Applicability" /t REG_SZ /v Ring /d "External" /f
rem reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Applicability" /t REG_SZ /v ContentType /d "Mainline" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\Applicability" /t REG_SZ /v BranchName /d "%Channel%" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI\Strings" /t REG_SZ /v StickyXaml /d "<StackPanel xmlns="^""http://schemas.microsoft.com/winfx/2006/xaml/presentation"^""><TextBlock Style="^""{StaticResource BodyTextBlockStyle }"^"">本设备已被添加至 Windows 预览体验计划</TextBlock><TextBlock Text="^""被应用的设置"^"" Margin="^""0,20,0,10"^"" Style="^""{StaticResource SubtitleTextBlockStyle}"^"" /><TextBlock Style="^""{StaticResource BodyTextBlockStyle }"^"" Margin="^""0,0,0,5"^""><Run FontFamily="^""Segoe MDL2 Assets"^"">&#xECA7;</Run> <Span FontWeight="^""SemiBold"^"">%Fancy%</Span></TextBlock><TextBlock Text="^""更新通道: %Channel%"^"" Style="^""{StaticResource BodyTextBlockStyle }"^"" /><TextBlock Text="^""更新目录: Mainline"^"" Style="^""{StaticResource BodyTextBlockStyle }"^"" /><TextBlock Text="^""Telemetry settings notice"^"" Margin="^""0,20,0,10"^"" Style="^""{StaticResource SubtitleTextBlockStyle}"^"" /><TextBlock Style="^""{StaticResource BodyTextBlockStyle }"^"">Windows Insider 计划要求将您的诊断数据收集设置设为 <Span FontWeight="^""SemiBold"^"">全部</Span>. 您可以点击如下按钮验证或修改您当前的设置 <Span FontWeight="^""SemiBold"^"">诊断 &amp; 反馈</Span>.</TextBlock><Button Command="^""{StaticResource ActivateUriCommand}"^"" CommandParameter="^""ms-settings:privacy-feedback"^"" Margin="^""0,10,0,0"^""><TextBlock Margin="^""5,0,5,0"^"">打开诊断 &amp; 反馈</TextBlock></Button></StackPanel>" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /t REG_DWORD /v UIHiddenElements /d 65535 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /t REG_DWORD /v UIDisabledElements /d 65535 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /t REG_DWORD /v UIServiceDrivenElementVisibility /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /t REG_DWORD /v UIErrorMessageVisibility /d 192 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /t REG_DWORD /v AllowTelemetry /d 3 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /t REG_DWORD /v BranchReadinessLevel /d %BRL% /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI\Strings" /t REG_SZ /v StickyMessage /d "{"^""Message"^"":"^""使用 Windows Insider 离线注册工具 中文版 注册的设备"^"","^""LinkTitle"^"":"^"""^"","^""LinkUrl"^"":"^"""^"","^""DynamicXaml"^"":"^""<StackPanel xmlns=\\"^""http://schemas.microsoft.com/winfx/2006/xaml/presentation\\"^""><TextBlock Style=\\"^""{StaticResource BodyTextBlockStyle }\\"^"">本设备已被添加至Windows预览体验计划</TextBlock><TextBlock Text=\\"^""Applied configuration\\"^"" Margin=\\"^""0,20,0,10\\"^"" Style=\\"^""{StaticResource SubtitleTextBlockStyle}\\"^"" /><TextBlock Style=\\"^""{StaticResource BodyTextBlockStyle }\\"^"" Margin=\\"^""0,0,0,5\\"^""><Run FontFamily=\\"^""Segoe MDL2 Assets\\"^"">&#xECA7;</Run> <Span FontWeight=\\"^""SemiBold\\"^"">%Fancy%</Span></TextBlock><TextBlock Text=\\"^""Channel: %Channel%\\"^"" Style=\\"^""{StaticResource BodyTextBlockStyle }\\"^"" /><TextBlock Text=\\"^""Content: Mainline\\"^"" Style=\\"^""{StaticResource BodyTextBlockStyle }\\"^"" /><TextBlock Text=\\"^""Telemetry settings notice\\"^"" Margin=\\"^""0,20,0,10\\"^"" Style=\\"^""{StaticResource SubtitleTextBlockStyle}\\"^"" /><TextBlock Style=\\"^""{StaticResource BodyTextBlockStyle }\\"^"">Windows 预览体验计划要求将诊断数据收集设置设为 <Span FontWeight=\\"^""SemiBold\\"^"">完整</Span>。 您可以点击如下按钮验证或修改您当前的设置 <Span FontWeight=\\"^""SemiBold\\"^"">Diagnostics &amp; feedback</Span>.</TextBlock><Button Command=\\"^""{StaticResource ActivateUriCommand}\\"^"" CommandParameter=\\"^""ms-settings:privacy-feedback\\"^"" Margin=\\"^""0,10,0,0\\"^""><TextBlock Margin=\\"^""5,0,5,0\\"^"">Open Diagnostics &amp; feedback</TextBlock></Button></StackPanel>"^"","^""Severity"^"":0}" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /t REG_DWORD /v UIHiddenElements_Rejuv /d 65534 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /t REG_DWORD /v UIDisabledElements_Rejuv /d 65535 /f
goto :EOF

:ENROLL
echo 正在应用设置 ... ...
call :RESET_INSIDER_CONFIG 1>NUL 2>NUL
call :ADD_INSIDER_CONFIG 1>NUL 2>NUL
bcdedit /set {current} flightsigning yes >NUL 2>&1
echo 成功！

echo.
IF %FlightSigningEnabled% NEQ 1 goto :ASK_FOR_REBOOT
pause
goto :EOF

:STOP_INSIDER
echo 正在应用设置 ... ...
call :RESET_INSIDER_CONFIG 1>NUL 2>NUL
bcdedit /deletevalue {current} flightsigning >NUL 2>&1
echo 成功！

echo.
IF %FlightSigningEnabled% NEQ 0 goto :ASK_FOR_REBOOT
pause
goto :EOF

:ASK_FOR_REBOOT
set "choice="
echo 需要重新启动才能应用更改。
set /p choice="你想现在重新启动你的电脑吗？ (y/N) "
if /I "%choice%"=="y" shutdown -r -t 0
goto :EOF
