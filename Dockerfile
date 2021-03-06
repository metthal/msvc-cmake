# escape=`

FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2016


SHELL ["cmd", "/S", "/C"]

ADD https://aka.ms/vs/16/release/channel C:\TEMP\VisualStudio.chman

ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
	--channelUri C:\TEMP\VisualStudio.chman `
	--installChannelUri C:\TEMP\VisualStudio.chman `
	--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended `
	--installPath C:\BuildTools `
	|| IF "%ERRORLEVEL%"=="3010" EXIT 0

RUN powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

RUN choco install -Y cmake --version 3.16.2 --installargs 'ADD_CMAKE_TO_PATH=System'

ENTRYPOINT C:\BuildTools\Common7\Tools\VsDevCmd.bat &&
CMD powershell.exe -NoLogo -ExecutionPolicy Bypass