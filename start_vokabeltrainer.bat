@echo off
title Vokabeltrainer Italienisch (Entwurf)
cd /d "%~dp0"

:loop
echo [%date% %time%] Server wird gestartet... >> server_log.txt
python main.py >> server_log.txt 2>&1
echo [%date% %time%] Server beendet (Exitcode %ERRORLEVEL%) - Neustart in 3 Sek. Zum Beenden Fenster schliessen oder STRG+C. >> server_log.txt
timeout /t 3 /nobreak >nul
goto loop
