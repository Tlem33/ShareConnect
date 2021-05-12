:: ShareConnect+.cmd Cr�er par Tlem33
:: Connecte un ou plusieurs partage sur diff�rents lecteurs r�seau.
::
:: Lire le fichier README.md pour plus d'informations.
::
:: Version 1.9 du 11/05/2021
:: https://github.com/Tlem33/ShareConnect
::

@Echo Off
Cls
Set Version=1.9

:: On ce place dans le dossier du batch (Auto Map drive if UNC).
PushD %~DP0

Set Err=0
Set NetExe=%Windir%\System32\net.exe
Set LogFile=SharesConnect.log
Set IniFile=SharesConnect+.ini
Call :CheckIni

:: Lecture de la valeur de temporisation
For /F "Tokens=1,2 Delims==" %%a In (%IniFile%) Do (
If %%a==Timer Set Timer=%%b
)
:: Au cas ou Timer ne serait pas renseign�.
If "%Timer%"=="" Set Timer=10

:Titre
Echo				%~n0 v%version%
Echo.&Echo.
:: Timer de connexion
Echo Connexion du/des partages r�seau dans %Timer% secondes.
Echo Merci de patienter ...
Echo.
Ping -n %Timer% 127.0.0.1>Nul

Echo Log SharesConnect du %date% � %Time%>%LogFile%
Echo ==========================================================================>>%LogFile%

:: Boucle de lecture des param�tres et connexion des lecteurs r�seau :
:Loop
Set /a Nb+=1
Set Drive=
Set Share=
Set User=
Set Pass=


:: Boucle de lecture du fichier .ini. Usebackq permet d'utiliser les guillemets et les chemin long.
For /F "Usebackq Tokens=1,2 Delims==" %%a In ("%~DP0%IniFile%") Do (
If /I %%a==Drive%Nb% Set Drive=%%b
If /I %%a==Share%Nb% Set Share=%%b
If /I %%a==User%Nb% Set User=%%b
If /I %%a==Pass%Nb% Set Pass=%%b
)

If "%Drive%"=="" Goto :Fin

Echo ==========================================================================
Call :ConnectDrive
Echo ==========================================================================
Echo.
Goto :Loop


:Fin
If %Err%==0 (
	Call :SuccessMsg
	Echo Tous les lecteurs r�seau ont �t� connect�s avec succes.
	Echo Tous les lecteurs r�seau ont �t� connect�s avec succes.>>%LogFile%
	Echo.
	Echo Fermeture de cette fen�tre dans 10 secondes.
	Ping -n 10 127.0.0.1>Nul
) Else (
	Call :ErrorMsg
	Echo Tous les lecteurs r�seau n'ont pas �t� connect�s ...
	Echo Tous les lecteurs r�seau n'ont pas �t� connect�s ...>>%LogFile%
	Echo Veuillez consulter les messages pr�c�dent pour plus d'information.
	Call :Pause
)
Exit


:ConnectDrive
:: Test si la lettre de lecteur est utilis�e et/ou disponible
If Exist "%Drive%:\*.*" Call :TestDrive
If "%DriveError%"=="1" Set Err=1 & Goto :EOF

:: Si le partage est d�j� connect� => Actualisation
If /I "%Share%"=="%ShareConnected%" (
	Echo Actualisation du partage ...
	Echo Actualisation du partage ...>>%LogFile%
) Else (
	Echo Connexion du partage %Share% sur le lecteur %Drive% en cours ...
	Echo Connexion du partage %Share% sur le lecteur %Drive% en cours ...>>%LogFile%
)


:: Connexion du partage :
If "%User%" NEQ "" (
	"%NetExe%" Use %Drive%: %Share% /Persistent:No /User:%User% %Pass%>NUL 2>NUL
) ELSE (
	"%NetExe%" Use %Drive%: %Share% /Persistent:No>NUL 2>NUL
)

::Echo D�sactivation de la d�connexion automatique par Windows.
"%NetExe%" Config Server /autodisconnect:-1>Nul 2>Nul

::Pause de 2 secondes
Ping -n 2 127.0.0.1>NUL

:: Test de la r�ussite de la connexion :
If Not Exist %Drive%:\*.* (
	Echo Le lecteur %Drive% n'a pas pu �tre connect�.
	Echo Le lecteur %Drive% n'a pas pu �tre connect�.>>%LogFile%
	Set Err=1
) Else (
	Echo Le lecteur %Drive% a bien �t� connect�.
	Echo Le lecteur %Drive% a bien �t� connect�.>>%LogFile%
)
Goto :eof


:CheckIni
If Not Exist "%~DP0%IniFile%" (
	Call :ErrorMsg
	Echo Le fichier de configuration "%IniFile%" n'a pas �t� trouv�.>>%LogFile%
	Echo Le fichier de configuration "%IniFile%" n'a pas �t� trouv�.
	Echo Veuillez relancer le programme "Setup.cmd" afin d'en g�n�rer
	Echo un nouveau et veuillez indiquer vos param�tres dans celui-ci.
	Call :Pause
	Exit
)
Goto :EOF


:TestDrive
Set DriveError=0
Set DriveConnected=0

%NetExe% Use %Drive%:>Nul 2>Nul
If "%errorlevel%" NEQ "0" (
	Echo Le lecteur %Drive%: n'est pas disponible pour une connexion de partage.
	Echo Le lecteur %Drive%: n'est pas disponible pour une connexion de partage.>>%LogFile%
	Set DriveError=1
	Goto :EOF
)

:: R�cup�re les infos du lecteur Z: si d�j� connect�.
For /F "tokens=1,2,3" %%a In ('%NetExe% Use %Drive%: ^| findstr /i "Nom distant"') Do Set ShareConnected=%%c

:: Test si le partage est d�j� connect� sur le lecteur.
If /I "%Share%"=="%ShareConnected%" (
	Echo Le partage "%Share%" est d�j� connect� sur le lecteur %Drive%: !
	Echo Le partage "%Share%" est d�j� connect� sur le lecteur %Drive%: !>>%LogFile%
) Else (
	Echo Le lecteur %Drive% est d�j� utilis� pour le partage "%Share%" !
	Echo Le lecteur %Drive% est d�j� utilis� pour le partage "%Share%" !>>%LogFile%
	Set DriveError=1
)
Goto :EOF


:ErrorMsg
Color 0C
Echo.
Echo                          ��������������������������ͻ
Echo                          �                          �
Echo                          �          ERREUR          �
Echo                          �                          �
Echo                          ��������������������������ͼ
Echo.
Echo.
Goto :EOF


:InformationMsg
Color 0E
Echo.
Echo                          ��������������������������ͻ
Echo                          �                          �
Echo                          �       INFORMATION        �
Echo                          �                          �
Echo                          ��������������������������ͼ
Echo.
Echo.
Goto :EOF


:SuccessMsg
Color 0A
Echo.
Echo                          ��������������������������ͻ
Echo                          �                          �
Echo                          �          SUCCES          �
Echo                          �                          �
Echo                          ��������������������������ͼ
Echo.
Echo.
Goto :EOF


:Pause
Echo ==========================================================================>>%LogFile%
Echo Fin de traitement SharesConnect>>%LogFile%
Echo.
Echo.
Echo Appuyez sur une touche pour quitter.
Pause>Nul
Goto :EOF

:EOF
