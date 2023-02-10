@ECHO OFF

pushd %~dp0

REM Minimal makefile for containerized SLATE Remote Client (in-progress)

set IMAGENAME=slate-remote-client
set IMAGETAG=local
set VERSION="latest"

docker version >NUL 2>NUL
if errorlevel 9009 (
	echo.
	echo.The 'docker' command was not found. Make sure you have Docker
	echo.installed.
	echo.
	echo.If you don't have Docker installed, grab it from
	echo.https://docs.docker.com/desktop/windows/install/
	exit /b 1
)

if "%1" == "build"
docker build --file Dockerfile --build-arg slateclientversion=%VERSION% --tag %IMAGENAME%:%IMAGETAG% .
goto end

if "%1" == "build-nocache"
docker build --file Dockerfile --build-arg slateclientversion=%VERSION% --tag %IMAGENAME%:%IMAGETAG% --no-cache .
goto end

if "%1" == "clean"
docker image rm %IMAGENAME%:%IMAGETAG% -f

if "%1" == "local" goto :env
if "%1" == "dev" goto :env
if "%1" == "staging" goto env
if "%1" == "prod" goto env
if "%1" == "prod2" goto env

:env
docker build --file Dockerfile --build-arg slateclientversion=%VERSION% --tag %IMAGENAME%:%IMAGETAG% .
docker run -it^
 -v %~dp0/work:/work^
 --env SLATE_ENV=%1^
 --name %IMAGENAME%-%1^
 %IMAGENAME%:%IMAGETAG%
ECHO Removing old containers......................
docker container rm $%IMAGENAME%-%1
goto end

:end
popd
