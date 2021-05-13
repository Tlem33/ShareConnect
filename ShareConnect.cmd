:: ShareConnect.cmd - Par Tlem33
:: Connecte un partage sur un lecteur réseau.
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

:: ================================================================================
::                               CONFIGURATION
:: ================================================================================
Set Timer=10
Set Drive=Z
Set Share=\\Serveur\D
Set User=
Set Password=
:: ================================================================================


:Titre
Echo				%~n0 v%version%
Echo.&Echo.
:: Timer de connexion
Echo Merci de patienter %Timer% secondes pour la connexion
Echo du partage %Share% sur le lecteur %Drive%:
Echo.
Echo.
Ping -n %Timer% 127.0.0.1>Nul


:: Récupère les infos du lecteur Z: si déjà connecté.
For /F "tokens=1,2,3" %%a In ('Net Use %Drive%: ^| findstr /i "Nom distant"') Do (
	Set ShareConnected=%%c
)


Cls
:Titre
Echo				%~n0 v%version%
Echo.&Echo.


If "%ShareConnected%"=="" Goto Connection
If "%Share%"=="%ShareConnected%" Goto Connection

If "%Share%" NEQ "%ShareConnected%" (
	Color 0C
	Echo.
	Echo Le lecteur %Drive%: est d‚j… connect‚ sur le partage %ShareConnected%
	Call :OKConnect
)
If Exist %Drive%:\*.* (
	Color 0C
	Echo.
	Echo  Le lecteur %Drive%: n'est pas disponible pour un connexion de partage.
	Call :Erreur
)

:Connection
Color 0E
Echo Connexion du partage %Share% sur le lecteur %Drive%: en cours ...
If "%User%" NEQ "" (
	Net Use %Drive%: %Share% /Persistent:No /User:%User% %Password%>NUL 2>NUL
) ELSE (
	Net Use %Drive%: %Share% /Persistent:No>NUL 2>NUL
)

:: Désactivation de la déconnexion automatique par Windows.
"%NetExe%" Config Server /autodisconnect:-1>Nul 2>Nul

If "%1"=="" (
	Ping -n 2 127.0.0.1>NUL
)

If Not Exist %Drive%:\*.* (
	Color 0C
	Echo.
	Echo Le partage %Share% est inaccessible ou le lecteur %Drive%: est indisponible.
	Call :Erreur
)

:OKConnect
If "%1"=="" (
	Color 0A
	Echo.
	Echo                   ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
	Echo                   º                                          º
	Echo                   º       Partage connect‚ avec succ‚s       º
	Echo                   º                                          º
	Echo                   ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
	Echo.
	Echo.
	Echo.
	Echo Le partage %Share% … ‚t‚ connect‚ sur le lecteur %Drive%:
	Ping -n 5 127.0.0.1>NUL
)
Exit

:Erreur
	Echo.
	Echo.
	Echo.
	Echo.
	Echo.
	Echo.
	Echo.
	Echo                   ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
	Echo                   º                                          º
	Echo                   º  Erreur lors de la connexion du partage  º
	Echo                   º                                          º
	Echo                   ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
	Echo.
	Echo.
	Echo.
	Echo.
	Echo.
	Echo.
	Echo.
	Echo.
	Echo.
	Echo Appuyez sur une touche pour fermer cette fenˆtre.
	Pause>NUL
	Exit

