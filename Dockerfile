# escape=`

FROM microsoft/dotnet-framework:4.7.2-runtime

SHELL ["cmd", "/S", "/C"]

ADD https://aka.ms/vs/15/release/channel C:\TEMP\VisualStudio.chman

ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
	--channelUri C:\TEMP\VisualStudio.chman `
	--installChannelUri C:\TEMP\VisualStudio.chman `
	--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended `
	--installPath C:\BuildTools `
	|| IF "%ERRORLEVEL%"=="3010" EXIT 0

RUN powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

RUN choco install -Y cmake

ENTRYPOINT C:\BuildTools\Common7\Tools\VsDevCmd.bat &&
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
