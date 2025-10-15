@echo off
setlocal enableextensions

REM === 1) Entradas del usuario ===
set /p NAME=Introduce el nombre que quieres usar (ej. ACME S.L.): 
set /p INCERR=Quieres incluir el "Informe de Errores"? (S/N): 

:VALIDAR_RESPUESTA
if /I "%INCERR%"=="S" goto :RESPUESTA_OK
if /I "%INCERR%"=="N" goto :RESPUESTA_OK
echo Respuesta no valida. Escribe S o N.
set /p INCERR=¿Quieres incluir el "Informe de Errores"? (S/N): 
goto :VALIDAR_RESPUESTA

:RESPUESTA_OK

REM === 2) Carpeta destino en Documentos ===
set "BASE=%USERPROFILE%\Documents\(%NAME%) Informe Revision Accesibilidad"
if not exist "%BASE%" mkdir "%BASE%" >nul 2>&1

REM === 3) URLs RAW de GitHub (usar raw.githubusercontent.com) ===
set "URL_DECLARACION=https://raw.githubusercontent.com/aek676/Plantillas-IRA-TuWebAccesible/main/Declaracion%20Accesibilidad.docx"
set "URL_REVISION=https://raw.githubusercontent.com/aek676/Plantillas-IRA-TuWebAccesible/main/Informe%20Revision%20Accesibilidad%20Kit-digital.xlsx"
set "URL_ERRORES=https://raw.githubusercontent.com/aek676/Plantillas-IRA-TuWebAccesible/main/Informe%20de%20errores.docx"

REM === 4) Nombres de salida con el prefijo (nombre) ===
set "OUT_DECLARACION=%BASE%\(%NAME%) Declaracion de Accesibilidad.docx"
set "OUT_REVISION=%BASE%\(%NAME%) Informe Revision Accesibilidad.xlsx"
set "OUT_ERRORES=%BASE%\(%NAME%) Informe de Errores.docx"

echo.
echo Descargando archivos en: "%BASE%"
echo.

cd "%BASE%"

REM --- Declaracion de Accesibilidad ---
curl -o "%OUT_DECLARACION%" "%URL_DECLARACION%"
if errorlevel 1 (
  echo [ERROR] No se pudo descargar Declaracion de Accesibilidad.
  goto :FIN
)

REM --- Informe Revision Accesibilidad Kit-digital ---
curl -o "%OUT_REVISION%" "%URL_REVISION%"
if errorlevel 1 (
  echo [ERROR] No se pudo descargar Informe Revision Accesibilidad Kit-digital.
  goto :FIN
)

REM --- Informe de Errores (opcional) ---
if /I "%INCERR%"=="S" (
  curl -o "%OUT_ERRORES%" "%URL_ERRORES%"
  if errorlevel 1 (
    echo [ERROR] No se pudo descargar Informe de Errores.
    goto :FIN
  )
)

echo.
echo Listo. Archivos creados en:
echo    "%BASE%"
echo.

:FIN
echo.
pause
endlocal
exit /b 0
