@echo off
setlocal enabledelayedexpansion
chcp 437 >nul
pushd %~dp0

:: <Config>
set "Default=[0m" & set "bgwhite=[107m" & set "bgblack=[40m" & set "bgyellow=[43m" & set "black=[30m" & set "red=[91m" & set "green=[92m" & set "yellow=[93m" & set "blue=[34m" & set "magenta=[35m" & set "cyan=[36m" & set "white=[37m" & set "grey=[90m" & set "brightred=[91m" & set "brightgreen=[92m" & set "brightyellow=[93m" & set "brightblue=[94m" & set "brightmagenta=[95m" & set "brightcyan=[96m" & set "brightwhite=[97m" & set "underline=[4m" & set "underlineoff=[24m"
title Devices Info Collection
cls
:: </Config>

:: <Arguments>
set "EmojiID=%~1"
set "Format=%~2"

if defined !EmojiID! (
    echo !red!ERROR: !Default!Didn't specify emoji ID. The script will exit
    pause >nul 2>&1
    exit /b
)

if defined !Format! (
    echo !red!ERROR: !Default!Didn't specify save extension. The script will exit
    pause >nul 2>&1
    exit /b
)

:: <Main>
for %%a in (gif png jpg) do (
    if !Format!==%%a (
        if /i !Format!==gif (
            call :Download gif
            exit /b
        ) else (
            call :Download webp
            exit /b
        )
    )
)

echo !red!ERROR: !Default!Specified wrong extension "!Format!", available extensions are "gif, png, jpg". The script will exit
pause >nul 2>&1
exit /b

:: </Main>

:: <Check net connection>
:TestConnection
ping -a google.com -n 1 -l 1 >nul 2>&1
if !errorlevel! neq 0 (
    echo !red!ERROR: !Default!No internet connection. The script will exit
    pause >nul 2>&1
    exit /b
)

exit /b

:: </Check net connection>

:: <Download the emoji>
:Download
set "urltype=%~1"

call :TestConnection
curl -Is "https://cdn.discordapp.com/emojis/!EmojiID!.!urltype!?size=128&quality=lossless" | findstr /c:"200 OK" >nul 2>&1
if !errorlevel! neq 0 (
    call :TestConnection
    echo !yellow!WARNING: !Default!Emoji ID exists, however the script can't download it because it doesn't exist either it's corrupted or unacessible. The script will exit
    pause >nul 2>&1
    exit /b
)
curl --ssl-no-revoke --create-dirs -L# "https://cdn.discordapp.com/emojis/!EmojiID!.!urltype!?size=128&quality=lossless" -o "!__cd__!!EmojiID!-emojidownloader.!Format!"
echo.
echo !green!INFO: !Default!Successfuly downloaded emoji !EmojiID!. It is now located in !__cd__! as !EmojiID!-emojidownloader.!Format!
exit /b

:: </Download the emoji>

exit /b