:: Setup.cmd - Créer par Tlem33
:: Programme d'installation et de désinstallation pour ShareConnect.
::
:: Lire le fichier README.md pour plus d'informations.
::
:: Version 1.9 du 11/05/2021
:: https://github.com/Tlem33/ShareConnect
::

@Echo Off
Cls

:: Permet de mapper un lecteur automatiquement si le programme est lancé depuis un chemin UNC
:: popd avant de quitter le script permet de fermer le lecteur mappé.
pushd %~dp0

:: On lit les paramètres d'installation
Set SetupIni=%~DP0setup.ini
Call :ReadSetupIni

:: On demande les droits admin si necessaire (Si Admin=1 ou Desktop=2 ou Startup=2).
Set PowerShellExe="%WINDIR%\system32\WindowsPowerShell\v1.0\powershell.exe"
If %Admin% EQU 1 Net.exe session 1>NUL 2>NUL || (%PowerShellExe% start-process """%~dpnx0""" -verb RunAs & Exit /b 1)
If %Link2Desktop% EQU 2 Net.exe session 1>NUL 2>NUL || (%PowerShellExe% start-process """%~dpnx0""" -verb RunAs & Exit /b 1)
If %Link2Startup% EQU 2 Net.exe session 1>NUL 2>NUL || (%PowerShellExe% start-process """%~dpnx0""" -verb RunAs & Exit /b 1)

:: Gestion textuelle des paramètres d'installation
If "%Link2Desktop%" EQU "0" (
	Set sLink2Desk=Raccourci Bureau       : Non
) Else (
	Set sLink2Desk=Raccourci Bureau       : Oui
)

If "%Link2Startup%" EQU "0" (
	Set sLink2Start=D‚marrage auto         : Non
) Else (
	Set sLink2Start=D‚marrage auto         : Oui
)


:Titre
Cls
Echo				Setup %AppName% %Version%
Echo                         ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
Echo.
Echo.


:Choix
Echo Dossier d'installation : %InstallDir%
Echo Nom du raccourci       : %LinkName% %Version%
Echo %sLink2Desk%
Echo %sLink2Start%
Echo.
Echo.
Echo Choisissez l'action … effecter :
Echo.
Echo.
Echo      1 - Installer %LinkTarget1:~0,-4%  %Version% ^(%Desc1%^)
Echo.
Echo      2 - Installer %LinkTarget2:~0,-4% %Version% ^(%Desc2%^)
Echo.
Echo      3 - D‚sinstaller %AppName% %Version%
Echo.
Echo      4 - Quitter
Echo.
Echo.
Echo.
Echo.
Choice /c 1234 /m "Entrez votre choix : "
If %Errorlevel%==4 popd & Exit
If %Errorlevel%==3 Goto :Uninstall
If %Errorlevel%==2 Set LinkTarget=%LinkTarget2% & Goto :Install
If %Errorlevel%==1 Set LinkTarget=%LinkTarget1% & Goto :Install
Goto :Titre


:Install
Echo.
:: Suppression du fichier .Log si existant
If Exist "%~dp0*.log" Del /F /Q "%~dp0*.log"

:: Suppression du raccourci existant du dossier d'installation (évite l'accumulation de N° de version)
If Exist "%InstallDir%\%LinkName%*.lnk" Del /F /Q "%InstallDir%\%LinkName%*.lnk"

:: Copie des fichiers vers le dossier d'installation
Echo Copie des fichiers dans le dossier "%InstallDir%"
XCopy "%~dp0*.*" "%InstallDir%\" /Y

:: Création du raccourci dans le dossier d'installation.
Call :CreateLink "%InstallDir%" "%LinkName% %Version%"

:: Mise en place des raccourcis Bureau et Menu Démarrer:
If Exist "%InstallDir%\%LinkName% %Version%.lnk" (
	Echo.
	Set Msg=Mise en place du raccourcis
	If %Link2Startup% EQU 1 Call :CreateLink "UserStartup" "%LinkName% %Version%"
	If %Link2Startup% EQU 2 Call :CreateLink "AllUsersStartup" "%LinkName% %Version%"
	If %Link2Desktop% EQU 1 Call :CreateLink "UserDesktop" "%LinkName% %Version%"
	If %Link2Desktop% EQU 2 Call :CreateLink "AllUsersDesktop" "%LinkName% %Version%"
)

If Exist "%InstallDir%\%~nx0" (
	Call :SuccessMSG
	Echo Installation termin‚e avec succŠs.
) Else (
	Call :ErrorMSG
	Echo Erreur lors de l'installation.
	Echo Lisez les messages ci-dessus pour connaitre la raison de l'erreur.
)
Call :Exit


:Uninstall
Set UninstallFile="%Temp%\%LinkName%_Uninstall.cmd"

Echo Echo Suppression des raccourcis.>>%UninstallFile%
Call :DeleteLink  "%LinkName% %Version%"

Echo @Echo Off>%UninstallFile%
Echo Cls>>%UninstallFile%
Echo Ping -n3 127.0.0.1^>Nul>>%UninstallFile%
Echo.>>%UninstallFile%
Echo :Delete>>%UninstallFile%
Echo Set /A X+=^1>>%UninstallFile%
Echo Echo Suppression du r‚pertoire d'installation.>>%UninstallFile%
Echo RD /S /Q "%InstallDir%">>%UninstallFile%
Echo Echo.>>%UninstallFile%
Echo If %%X%% GEQ 500 Goto :Check>>%UninstallFile%
Echo If Exist "%InstallDir%" Goto :Delete>>%UninstallFile%
Echo.>>%UninstallFile%
Echo :Check>>%UninstallFile%
Echo If Exist "%InstallDir%" ^(>>%UninstallFile%
Echo 	Color 0C>>%UninstallFile%
Echo 	Echo Erreur lors de la d‚sinstallation.>>%UninstallFile%
Echo 	Echo Lisez les messages ci-dessus pour connaitre la raison de l'erreur.>>%UninstallFile%
Echo ^) Else ^(>>%UninstallFile%
Echo 	Color 0A>>%UninstallFile%
Echo 	Echo D‚sinstallation termin‚e avec succŠs.>>%UninstallFile%
Echo ^)>>%UninstallFile%
Echo Echo.>>%UninstallFile%
Echo Echo.>>%UninstallFile%
Echo Echo Appuyez sur une touche pour terminer.>>%UninstallFile%
Echo Pause^>Nul>>%UninstallFile%
Echo.>>%UninstallFile%
Echo.>>%UninstallFile%
Echo :AutoDelete>>%UninstallFile%
Echo DEl /F /Q "%%~DPNX0" ^&^& Exit>>%UninstallFile%
Echo If Exist "%%~DPNX0" Goto :AutoDelete>>%UninstallFile%
Echo Exit>>%UninstallFile%

Call :Close_Window "%InstallDir%"

Start "Uninstall" /D "%Temp%" "%LinkName%_Uninstall.cmd"
popd & Exit


:ErrorMsg
Color 0C
Echo.
Echo                          ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
Echo                          º                          º
Echo                          º          ERREUR          º
Echo                          º                          º
Echo                          ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Echo.
Goto :EOF


:InformationMsg
Color 0E
Echo.
Echo                          ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
Echo                          º                          º
Echo                          º       INFORMATION        º
Echo                          º                          º
Echo                          ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Echo.
Goto :EOF


:SuccessMsg
Color 0A
Echo.
Echo                          ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
Echo                          º                          º
Echo                          º          SUCCES          º
Echo                          º                          º
Echo                          ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Echo.
Goto :EOF


:: Lecture du fichier Setup.ini
:ReadSetupIni
If Not Exist "%SetupIni%" Call :ErrorMsg & Echo Le fichier Setup.ini n'a pas ‚t‚ trouv‚ !!! & Call :Exit
:: Boucle de lecture du fichier .ini. Usebackq permet d'utiliser les guillemets et les chemin long.
For /F "Usebackq Tokens=1,2 Delims==" %%a In ("%SetupIni%") Do (
	If /I %%a==AppName Set AppName=%%b
	If /I %%a==Version Set Version=%%b
	If /I %%a==InstallDir Set InstallDir=%%b
	If /I %%a==LinkName Set LinkName=%%b
	If /I %%a==LinkTarget1 Set LinkTarget1=%%b
	If /I %%a==Desc1 Set Desc1=%%b
	If /I %%a==LinkTarget2 Set LinkTarget2=%%b
	If /I %%a==Desc2 Set Desc2=%%b
	If /I %%a==Admin Set Admin=%%b
	If /I %%a==Startup Set Link2Startup=%%b
	If /I %%a==Desktop Set Link2Desktop=%%b
	If /I %%a==DllIcon Set DllIcon=%%b
	If /I %%a==IconIndex Set IconIndex=%%b
)


:TestIniConfig
If "%InstallDir%" EQU "" Call :ErrorMsg & Echo InstallDir n'est pas renseign‚ !!! & Call :Exit
If "%LinkName%" EQU "" Call :ErrorMsg & Echo LinkName n'est pas renseign‚ !!! & Call :Exit

:: Réglages des Valeurs par défaut (si non renseignées).
If "%Version%" EQU "" Set Version=0.0
If "%Admin%" NEQ "0" Set Admin=1
:: Valeur par défaut de Link2Desktop
If "%Link2Desktop%" NEQ "1" (
	If "%Link2Desktop%" NEQ "2" (
		Set Link2Desktop=0
	)
)

:: Valeur par défaut de Link2Startup
If "%Link2Startup%" NEQ "1" (
	If "%Link2Startup%" NEQ "2" (
		Set Link2Startup=0
	)
)

:: Expansion des variables au cas ou des variables d'environement serait utilisées dans les chemins
Call :ExpandVar InstallDir "%InstallDir%"
Call :ExpandVar DllIcon "%DllIcon%"

If Not Exist "%DllIcon%" Set DllIcon=%systemroot%\System32\shell32.dll & Set IconIndex=24

:: Test si le dossier d'installation existe, ou s'il peux être créé.
If Not Exist "%InstallDir%" (
	MD "%InstallDir%">Nul 2>Nul
	If %ERRORLEVEL% EQU 1 (
		Call :ErrorMsg & Echo Le dossier d'installation n'est pas correct !!! & Call :Exit
	) Else (
		RD "%InstallDir%">Nul 2>Nul
	)
)
Goto :EOF


:: Création d'un raccourci vers %1 et dont le nom est %2
:CreateLink
Set sDst=%~1
Set sLinkName=%~2
Set TmpFile="%temp%\CreateShortCut.vbs"
Set Msg=Mise en place du raccourcis


:: Dossier installation
Echo Set WshShell = WScript.CreateObject("WScript.Shell")>%TmpFile%
Echo Set oMyShortcut = WshShell.CreateShortcut("%sDst%" + "\%sLinkName%.lnk")>>%TmpFile%

:: Bureau de l'utilisateur
If /I "%sDst%" EQU "UserDesktop" (
	Echo %Msg% sur le "Bureau utilisateur"
	Echo Set WshShell = WScript.CreateObject^("WScript.Shell"^)>%TmpFile%
	Echo strDesktop = WshShell.SpecialFolders^("Desktop"^)>>%TmpFile%
	Echo Set oMyShortcut = WshShell.CreateShortcut^(strDesktop + "\%sLinkName%.lnk"^)>>%TmpFile%
)

:: Bureau de tous les utilisateurs (Public)
If /I "%sDst%" EQU "AllUsersDesktop" (
	Echo %Msg% sur le "Bureau public"
	Echo Set WshShell = WScript.CreateObject^("WScript.Shell"^)>%TmpFile%
	Echo strDesktop = WshShell.SpecialFolders^("AllUsersDesktop"^)>>%TmpFile%
	Echo Set oMyShortcut = WshShell.CreateShortcut^(strDesktop + "\%sLinkName%.lnk"^)>>%TmpFile%
)

:: Menu Démarrer de l'utilisateur
If /I "%sDst%" EQU "UserStartup" (
	Echo %Msg% dans le "Menu D‚marrer de l'utilisateur"
	Echo Set WshShell = WScript.CreateObject^("WScript.Shell"^)>%TmpFile%
	Echo strStartup = WshShell.SpecialFolders^("Startup"^)>>%TmpFile%
	Echo Set oMyShortcut = WshShell.CreateShortcut^(strStartup + "\%sLinkName%.lnk"^)>>%TmpFile%
)

:: Menu Démarrer de tous les utilisateurs
If /I "%sDst%" EQU "AllUsersStartup" (
	Echo %Msg% dans le "Menu D‚marrer de tous les utilisateurs"
	Echo Set WshShell = WScript.CreateObject^("WScript.Shell"^)>%TmpFile%
	Echo strStartup = WshShell.SpecialFolders^("AllUsersStartup"^)>>%TmpFile%
	Echo Set oMyShortcut = WshShell.CreateShortcut^(strStartup + "\%sLinkName%.lnk"^)>>%TmpFile%
)

:: WindowStyle : 1 = Normale, 3 = Maximisée, 7 = Réduite
Echo oMyShortcut.WindowStyle = ^1>>%TmpFile%
Echo oMyShortcut.IconLocation = "%DllIcon%,%IconIndex%">>%TmpFile%
Echo OMyShortcut.TargetPath = "%InstallDir%\%LinkTarget%">>%TmpFile%
Echo OMyShortcut.Arguments = "">>%TmpFile%
Echo oMyShortCut.Save>>%TmpFile%
Call Cscript //Nologo %TmpFile%
Del /F /Q %TmpFile%
Goto :EOF


:: Suppression du raccourci sur : le bureau utilisateur, le bureau public, le menu Démarrer de l'utilisateur et de tous les utilisateurs.
:DeleteLink
Set TmpFile="%temp%\DeleteShortCut.vbs"
Set sFileLink="\%~1.lnk"
Echo Set WshShell = WScript.CreateObject("WScript.Shell")>%TmpFile%
Echo Set FSO = WScript.CreateObject("Scripting.FileSystemObject")>>%TmpFile%
Echo strDesktop = WshShell.SpecialFolders("Desktop")>>%TmpFile%
Echo strAllUsersDesktop = WshShell.SpecialFolders("AllUsersDesktop")>>%TmpFile%
Echo strStartup = WshShell.SpecialFolders("Startup")>>%TmpFile%
Echo strAllUsersStartup = WshShell.SpecialFolders("AllUsersStartup")>>%TmpFile%
Echo If FSO.FileExists(strDesktop + %sFileLink%) Then FSO.DeleteFile (strDesktop + %sFileLink%)>>%TmpFile%
Echo If FSO.FileExists(strAllUsersDesktop + %sFileLink%) Then FSO.DeleteFile (strAllUsersDesktop + %sFileLink%)>>%TmpFile%
Echo If FSO.FileExists(strStartup + %sFileLink%) Then FSO.DeleteFile (strStartup + %sFileLink%)>>%TmpFile%
Echo If FSO.FileExists(strAllUsersStartup + %sFileLink%) Then FSO.DeleteFile (strAllUsersStartup + %sFileLink%)>>%TmpFile%
Call Cscript //Nologo %TmpFile%
Del /F /Q %TmpFile%
Goto :EOF


:: Cette fonction permet d'étendre les variables d'environement qui
:: auraient été utilisées dans les variables des chemin par exemple.
:ExpandVar
Set %1=%~2
Goto :EOF


:: Permet de fermer la fenêtre Explorer du dossier d'installation si elle est ouverte.
:Close_Window <Window Name>
Set TmpFile="%Temp%\close_window.vbs"
(
    echo For Each window in CreateObject("shell.application"^).Windows
    echo     If window.document.folder.self.Path = WScript.Arguments.Item(0^) Then window.Quit
    echo Next
)>%TmpFile%
cscript //nologo %TmpFile% "%~1"
Ping -n 2 127.0.0.1>Nul
Del /F /Q %TmpFile%
Goto :EOF


:Exit
Echo.&Echo.
Echo Appuyez sur une touche pour quitter.
Popd
Pause>Nul
Exit
:EOF
