@echo off
:MENU
cls
for /f "delims=" %%i in ('git rev-parse --abbrev-ref HEAD') do set current_branch=%%i
echo ========================================
echo  Estas actualmente en la rama: %current_branch%
echo ========================================
echo.
echo 0. Salir
echo 1. Crear nueva FEATURE
echo 2. Finalizar FEATURE
echo 3. Crear nueva RELEASE
echo 4. Finalizar RELEASE
echo 5. Crear nuevo HOTFIX
echo 6. Finalizar HOTFIX
echo 7. Commit + Push
echo 8. Sincronizar rama actual (git pull)
echo 9. Cambiar de rama (git checkout)
echo.

set /p option=Introduce numero de opcion:

if "%option%"=="0" goto FIN
if "%option%"=="1" goto FEATURE_START
if "%option%"=="2" goto FEATURE_FINISH
if "%option%"=="3" goto RELEASE_START
if "%option%"=="4" goto RELEASE_FINISH
if "%option%"=="5" goto HOTFIX_START
if "%option%"=="6" goto HOTFIX_FINISH
if "%option%"=="7" goto COMMIT_PUSH
if "%option%"=="8" goto SYNC_CURRENT
if "%option%"=="9" goto CHANGE_BRANCH
echo Opcion no valida. Presiona una tecla para intentar de nuevo...
pause >nul
goto MENU

:FEATURE_START
set /p featname=Nombre de la nueva FEATURE:
git flow feature start %featname%
echo Feature '%featname%' creada y checkout realizado.
pause
goto MENU

:FEATURE_FINISH
set featname=%current_branch%
if /I "%featname:~0,8%"=="feature/" set featname=%featname:~8%
git flow feature finish %featname%
for /f %%i in ('git config --get gitflow.branch.develop') do set develop_branch=%%i
git push origin %develop_branch%
echo Feature '%featname%' finalizada.
pause
goto MENU

:RELEASE_START
set /p RELEASE_NAME=Nombre de la nueva RELEASE:
git flow release start %RELEASE_NAME%
echo Release '%RELEASE_NAME%' creada y checkout realizado.
pause
goto MENU

:RELEASE_FINISH
set relname=%current_branch%
if /I "%relname:~0,8%"=="release/" set relname=%relname:~8%
git flow release finish -m "Release %relname%" %relname%
git push origin main
git push origin develop
git push --tags
echo Release '%relname%' finalizada y subida al remoto.
pause
goto MENU

:HOTFIX_START
set /p hotfixname=Nombre del nuevo HOTFIX:
git flow hotfix start %hotfixname%
echo Hotfix '%hotfixname%' creado y checkout realizado.
pause
goto MENU

:HOTFIX_FINISH
set hotfixname=%current_branch%
if /I "%hotfixname:~0,7%"=="hotfix/" set hotfixname=%hotfixname:~7%
git flow hotfix finish %hotfixname%
git push origin main
git push origin develop
git push origin --tags
echo Hotfix '%hotfixname%' finalizado y subido al remoto..
pause
goto MENU

:COMMIT_PUSH
set /p commitmsg=Mensaje del commit:
git add .
git commit -m "%commitmsg%"
git push origin %current_branch%
echo Cambios commiteados y push realizados en rama '%current_branch%'.
pause
goto MENU

:SYNC_CURRENT
echo Sincronizando la rama actual '%current_branch%' con su remoto...
git pull origin %current_branch%
echo Sincronización completada.
pause
goto MENU

:CHANGE_BRANCH
set /p branchname=Nombre de la rama a cambiar:
git checkout %branchname%
if errorlevel 1 (
    echo Error al cambiar a la rama '%branchname%'. Puede que no exista.
) else (
    echo Cambiado a la rama '%branchname%'.
)
pause
goto MENU

:FIN
echo Saliendo...
exit /b
