# ShareConnect.cmd

Version 1.9 du 12/05/2021 - Par Tlem33
https://github.com/Tlem33/ShareConnect

---

## DESCRIPTION :

ShareConnect.bat est un utilitaire de connexion de partages réseau écrit par Tlem (tlem@tuxolem.fr).  
ShareConnect+.bat est l'évolution de ShareConnect.bat et permet la connexion de plusieurs partages.  

---

## INSTALLATION et DESINSTALLATION :
Lancez Setup.cmd et suivez les instructions.  
Vous pouvez éditez le fichier Setup.ini pour modifier les options d'installation.  

ShareConnect.bat peux fonctionner de manière autonome. Vous devez simplement éditer  
le programme pour rentrer les paramètres de connexion dans la section "CONFIGURATION".  

ShareConnect+.bat, utilise le fichier .ini pour lire les paramètres des différents partages à connecter.  

---

## UTILISATION :

### Pour la version simplifiée de ShareConnect, vous devez ouvrir  
le fichier ShareConnect.bat et modifier les paramètre ci-dessous :

      Timer=10              ; Permet de temporiser de 10 secondes le lancement de la connexion du partage.  
      Drive=Z               ; Lettre de lecteur pour la connexion du partage.  
      Share=\\Serveur\D     ; Chemin UNC du partage à connecter.  
      User=                 ; Nom de l'utilisateur (Si nécessaire).  
      Password=             ; Mot de passe  (Si nécessaire).  


### Pour la version ShareConnect+, vous devez éditez le fichier .ini pour  
indiquer les éléments concernant la ou les connexions du ou des partages.  

Timer=10                ; Permet de temporiser de 10 secondes le lancement de la connexion du partage  

Drive1=Z                ; Lettre de lecteur pour la connexion du 1er partage  
Share1=\\Serveur\D      ; Chemin UNC du 1er partage à connecter  
User1=                  ; Nom de l'utilisateur (Si nécessaire)  
Password1=              ; Mot de passe  (Si nécessaire)  

Drive2=                 ; Lettre de lecteur pour la connexion du second partage  
Share2=                 ; Chemin UNC du second partage à connecter  
User2=                  ; Nom de l'utilisateur (Si nécessaire)  
Password2=              ; Mot de passe  (Si nécessaire)  

Vous pouvez rajouter autant de partage que nécessaire en modifiant simplement la numérotation de chaque éléments.  

---

## SYSTEME(S) :

     Windows 7
     Windows 8
     Windows 10

---

## LICENCE :

Licence [MIT](https://fr.wikipedia.org/wiki/Licence_MIT)

Droit d'auteur (c) 2021 Tlem33

Une autorisation est accordée, gratuitement, à toute personne obtenant une copie de ce logiciel
et des fichiers de documentation associés (le «logiciel»), afin de traiter le logiciel sans restriction,
y compris et sans s’y limiter, les droits d’utilisation, de copie, de modification, de fusion, publiez,
distribuez, sous-licence et/ou vendez des copies du logiciel, et pour permettre aux personnes
auxquelles le logiciel est fourni, selon les conditions suivantes:

La notification du droit d’auteur ci-dessus et cette notification de permission doivent être incluses
dans toutes les copies ou portions substantielles du Logiciel.

LE LOGICIEL EST FOURNI « EN L’ÉTAT » SANS GARANTIE OU CONDITION D’AUCUNE SORTE, EXPLICITE OU IMPLICITE
NOTAMMENT, MAIS SANS S’Y LIMITER LES GARANTIES OU CONDITIONS RELATIVES À SA QUALITÉ MARCHANDE,
SON ADÉQUATION À UN BUT PARTICULIER OU AU RESPECT DES DROITS DE PARTIES TIERCES. EN AUCUN CAS LES
AUTEURS OU LES TITULAIRES DES DROITS DE COPYRIGHT NE SAURAIENT ÊTRE TENUS RESPONSABLES POUR TOUT
DÉFAUT, DEMANDE OU DOMMAGE, Y COMPRIS DANS LE CADRE D’UN CONTRAT OU NON, OU EN LIEN DIRECT OU
INDIRECT AVEC L’UTILISATION DE CE LOGICIEL.

---

## HISTORIQUE :

12/04/2014 - Version 1.0 - ShareConnect.bat  

		- Première version (connexion d'un seul partage et installation par Install.bat et Uninstall.bat).


17/08/2018 - Version 1.2 - Setup.cmd  

		- Fusion de l'installateur et du désinstallateur dans Setup.cmd.  
		- Ajout de la création du fichier .ini initial si inexistant.  
		- Ajout de la création automatique du raccourci (bureau et startup).  
		- Ajout et optimisation des messages de succés ou d'erreur.  
		- Amélioration du processus de désinstallation.  

22/08/2018 - Version 1.3 - SimpleShareConnect.cmd  

		- La première version (ShareConnect.bat) devient SimpleShareConnect.cmd.  
		- Modification du cadre des messages.  
		- Ajout de l'option /PERSISTENT:NO pour éviter le message de non reconnexion au démarrage du PC.  
		- Ajout de la désactivation de la déconnexion automatique Windows (Net Config Server /autodisconnect:-1).  

25/08/2018 - Version 1.4 - SharesConnect.cmd  

		- Ajout de l'utilisation d'un fichier .ini pour les différents paramètres.  
		- Ré-écriture du programme pour la gestion de plusieurs partages.  
		- Amélioration des pages de message.  
		- Ajout de l'option /PERSISTENT:NO pour éviter le message de non reconnexion au démarrage du PC.  
		- Ajout de la désactivation de la déconnexion automatique Windows (Net Config Server /autodisconnect:-1).  

02/09/2018 - Version 1.5 - Setup.cmd  

		- Modification du Setup pour proposer l'installation de l'un des deux batchs.  
		  La version simplifiée de SharesConnect devient le batch principal, car la connexion  
		  de partages multiples n'est pas la plus courante.  

02/09/2018 - Version 1.5 - SharesConnect.cmd et SimpleShareConnect.cmd  

		- Ajout du numéro de version en titre a l'affichage.  
		- Modification du nom des batchs :  
				- SharesConnect.cmd devient ShareConnect+.bat  
				- SimpleShareConnect.cmd devient ShareConnect.bat  
				- SharesConnect.ini devient ShareConnect.ini  

07/09/2018 - Version 1.6 - ShareConnect.bat, ShareConnect+.bat et Setup.cmd  

		- Correction d'un oubli sur l'option "Persistent" de la commande "Net Use".  
		- Modification du système d'installation. Utilisation d'un .Ini séparé.  
		- Simplification de ShareConnect.ini et ajout d'une description des fonctions.  
		- Fusion des corrections non prise en comptes lors de la diffusion de la version 1.5.  
		
17/10/2018 - Version 1.7 - Setup.cmd  

		- Modification importante concernant la gestion des raccourcis (par VBS).  
		- Suppression des liens vers dossiers personnalisés.  
		- Ajout d'un option "Startup" pour placer le raccourci dans le menu "Démarrer".  
		- Modification de la partie suppression des raccourcis (par VBS).  
		- Ajout de l'élévation de droits pour copier le raccourci sur le bureau Public.  

29/05/2019 - Version 1.8 - Setup.cmd  

		- Nettoyage du code (restes concernant dossiers personnalisés et fonctions non utilisées).  
		- Ré-écriture de la partie mise en place des raccourcis.  
		- Amélioration de la désinstallation.  
		- Actualisation des variables : Startup, Desktop, DllIcon (suppression préfix Link).  
		- Ajout de la possibilité de copier le raccourci dans le menu Démarrer de tous les utilisateurs.  
		- Ajout de commentaires au nom des programmes.  
		- Ajout d'informations d'installation sur affichage principal.  

12/05/2021 - Version 1.9 - README.md - LisezMoi.md - ShareConnect.cmd - ShareConnect+.cmd et Setup.cmd

		- Remplacement du LisezMoi.txt par README.md et LisezMoi.md.  
		- Je ne sais pas pour quelle raison obscure sur la version 1.5 j'ai choisi l'extension .bat.  
		  Je remet donc l'extension de base ".cmd".  ^^  
		- Mise à jour de l'entête de ShareConnect.cmd et ShareConnect+.cmd.  
		- Setup.cmd : Ajout d'une fonction de fermeture automatique lors de la désinstallation.  
		- Setup.cmd : Remplacement du mode de sélection des choix (Set /P => Choice). 
		- Setup.cmd renommé en ShareConnect-Setup.cmd.  
		
---
