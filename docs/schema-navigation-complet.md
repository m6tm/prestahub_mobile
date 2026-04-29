# 🗺️ Schéma de Navigation Schématique Complet

Ce document présente l'assemblage logique et les transitions entre tous les écrans réalisés. Il sert de plan de montage avant l'implémentation.

---

## 📱 Flux Client (User Flow)

```mermaid
graph TD
    %% Entrée & Auth
    Splash[Écran Chargement] --> Onboarding[Bienvenue / Onboarding]
    Onboarding --> Login[Connexion / Inscription]
    Login --> AuthSteps{Action}
    AuthSteps -->|OTP| OTP[Vérification OTP]
    AuthSteps -->|Reset| Reset[Réinitialisation MDP]
    OTP --> Home[Écran Accueil]

    %% Navigation Principale (Tab Bar)
    Home <--> Requests[Suivi Demandes]
    Home <--> ChatList[Liste Messages]
    Home <--> Profile[Profil Client]

    %% Sous-Flux : Recherche et Demande
    subgraph Discovery ["Module Recherche & Demande"]
        Home --> Categories[Choix Catégorie]
        Categories --> Search[Résultats Recherche]
        Search --> Filters[Filtres]
        Search --> PrestaDetail[Détail Prestataire]
        PrestaDetail --> CreateReq[Création Demande - Étapes]
        CreateReq --> Recap[Récapitulatif]
        Recap --> ConfirmReq[Confirmation Envoi]
        ConfirmReq --> Requests
    end

    %% Sous-Flux : Suivi Missions
    subgraph Operations_Client ["Module Suivi & Ops"]
        Requests --> ReqDetail[Détail Demande]
        ReqDetail --> Chat[Conversation Chat]
        Requests --> History[Historique Missions]
        History --> MissionPast[Détail Mission Passée]
        MissionPast --> Rating[Notation / Avis]
        Rating --> History
    end

    %% Sous-Flux : Profil & Paramètres
    subgraph Account_Client ["Module Compte & Paramètres"]
        Profile --> EditProfile[Édition Profil]
        Profile --> Addresses[Gestion Adresses]
        Addresses --> AddAddress[Ajout Adresse]
        Profile --> Security[Sécurité]
        Security --> ChangeMDP[Changement MDP]
        Security --> ManageOTP[Gestion OTP]
        Security --> Devices[Appareils Connectés]
        Profile --> Settings[Paramètres]
        Settings --> Lang[Langue]
        Settings --> Theme[Thème]
        Settings --> Notifs[Notifications]
        Settings --> Privacy[Confidentialité]
        Settings --> Geo[Géolocalisation]
        Profile --> Help[Aide / FAQ]
        Help --> FAQDetail[Détail Question]
        Help --> Contact[Contact Support]
        Help --> Report[Signalement Problème]
        Profile --> Legal[Infos Légales]
        Legal --> CGU[CGU]
        Legal --> PolPriv[Politique Privée]
    end

    %% Messagerie
    ChatList --> Chat
    Chat --> Call[Appel en cours]
```

---

## 🛠️ Flux Prestataire (Provider Flow)

```mermaid
graph TD
    %% Entrée & Auth Pro
    SplashP[Écran Chargement] --> OnboardingP[Bienvenue Prestataire]
    OnboardingP --> LoginP[Connexion / Inscription]
    LoginP --> OTP_P[Vérification OTP]
    OTP_P --> StartConfig[Guide Configuration]

    %% Sous-Flux : Configuration Profil Pro
    subgraph ConfigPro ["Module Configuration Pro"]
        StartConfig --> EditPro[Édition Profil Pro]
        EditPro --> Services[Gestion Services]
        Services --> Zones[Zones d'Intervention]
        Zones --> Tarifs[Tarifs Indicatifs]
        Tarifs --> Dispos[Disponibilités]
        Dispos --> Docs[Soumission Justificatifs]
        Docs --> VerifStatus[Statut Vérification]
        VerifStatus --> Dashboard[Tableau de Bord Leads]
    end

    %% Navigation Principale (Tab Bar)
    Dashboard <--> MissionsP[Suivi Missions]
    Dashboard <--> ReviewsP[Consultation Avis]
    Dashboard <--> ProfileP[Profil Pro]

    %% Sous-Flux : Gestion Leads & Missions
    subgraph Operations_Pro ["Module Leads & Missions"]
        Dashboard --> LeadDetail[Détail Demande Reçue]
        LeadDetail --> AcceptModal[Validation Accept/Refus]
        AcceptModal --> MissionsP
        MissionsP --> MissionDetailP[Détail Mission]
        MissionDetailP --> ChatP[Conversation Chat]
        MissionsP --> HistoryP[Historique Missions]
        HistoryP --> MissionPastP[Détail Mission Passée]
    end

    %% Sous-Flux : Avis & Réputation
    subgraph Reputation ["Module Avis"]
        ReviewsP --> ReviewDetail[Détail Avis]
        ReviewDetail --> Reply[Répondre à l'avis]
    end

    %% Sous-Flux : Profil & Paramètres (Identique Client)
    subgraph Account_Pro ["Module Compte Pro"]
        ProfileP --> SecurityP[Sécurité Pro]
        ProfileP --> SettingsP[Paramètres Pro]
        ProfileP --> HelpP[Aide Pro]
        ProfileP --> LegalP[Infos Légales Pro]
    end

    %% Messagerie Pro
    Dashboard <--> ChatListP[Liste Conversations]
    ChatListP --> ChatP
```

---

## 🔗 Transitions Critiques (Action/Réaction)

| Événement déclencheur | Écran Source | Écran Destination |
| :--- | :--- | :--- |
| **Envoi Demande** | Récapitulatif (Client) | Confirmation -> Suivi Demandes |
| **Acceptation Lead** | Détail Demande (Presta) | Missions en cours |
| **Fin de mission** | Détail Mission (Presta) | Détail Mission (Client) -> Notation |
| **Nouvel Avis** | Notification (Presta) | Détail de l'avis |
| **Alerte Support** | Signalement (Client) | Confirmation -> Accueil |

---
*Ce schéma constitue la base structurelle pour l'assemblage des écrans.*
