## 📱 Profil **Client**

### 1. Authentification & gestion de compte
- **Écran de bienvenue / onboarding**  
  Entités : Aucune (affichage statique)

- **Écran de connexion** (téléphone+OTP / email+mdp)  
  Entités : User (tentative de connexion), OTP (code temporaire)

- **Écran d’inscription** (téléphone, email, mdp, CGU)  
  Entités : User (création), Client (si rôle distinct), OTP

- **Écran de vérification OTP**  
  Entités : User, OTP

- **Écran de réinitialisation de mot de passe**  
  Entités : User, OTP, Session (utilisateur courant)

- **Écran de déconnexion** (confirmation)  
  Entités : Session (utilisateur courant)

### 2. Découverte et recherche de prestataires
- **Écran d’accueil** (catégories, suggestions)  
  Entités : ServiceCategory, Provider (pour suggestions), Review (pour notes), Address (localisation)

- **Écran de choix de catégorie**  
  Entités : ServiceCategory

- **Écran de résultats de recherche** (liste prestataires avec filtres)  
  Entités : Provider, ServiceCategory, Review, Address, Availability (si filtre dispo), User (pour infos de base)

- **Écran de filtres** (modale)  
  Entités : Provider (critères), Review (note), Address (distance), Availability

- **Écran de détail d’un prestataire**  
  Entités : Provider, User, Service (services proposés), Review, Address (zone), Document (justificatifs? visible?), Availability, Gallery (si photos)

### 3. Gestion des demandes de service
- **Écran de création de demande** (formulaire)  
  Entités : ServiceRequest (en cours de création), ServiceCategory, Address, Client, Provider (si ciblé), Document (photos jointes)

- **Écran de récapitulatif de la demande**  
  Entités : ServiceRequest (brouillon), Client, Provider, Address, Category

- **Écran de confirmation d’envoi**  
  Entités : ServiceRequest (envoyée)

- **Écran de suivi des demandes en cours** (liste)  
  Entités : ServiceRequest, Client, Provider, Status (état)

- **Écran de détail d’une demande**  
  Entités : ServiceRequest, Client, Provider, Address, Message (conversation), Status, Document (photos)

- **Écran d’historique des missions** (liste)  
  Entités : ServiceRequest (terminées/annulées), Client, Provider, Review (si déjà noté)

- **Écran de détail d’une mission passée**  
  Entités : ServiceRequest, Client, Provider, Review (avis laissé), Status

### 4. Messagerie
- **Écran de liste des conversations**  
  Entités : Conversation (ou Message groupé), ServiceRequest, Client, Provider, Message (dernier message)

- **Écran de conversation**  
  Entités : Message, ServiceRequest, Client, Provider, Document (pièces jointes)

### 5. Évaluation et avis
- **Écran de notation d’une mission terminée**  
  Entités : Review, ServiceRequest, Client, Provider

- **Écran de signalement d’un avis**  
  Entités : Review, Report (signalement), Client (signalant), Provider (concerné)

### 6. Profil personnel
- **Écran de profil client** (affichage)  
  Entités : Client, User, Address (liste)

- **Écran d’édition du profil**  
  Entités : Client, User

- **Écran de gestion des adresses** (liste)  
  Entités : Address, Client

- **Écran d’ajout / modification d’adresse**  
  Entités : Address, Client

### 7. Sécurité du compte
- **Écran de sécurité** (options)  
  Entités : User, Device (appareils connectés), OTP (configuration)

- **Écran de changement de mot de passe**  
  Entités : User (mot de passe)

- **Écran de gestion OTP**  
  Entités : User, OTP (activation/désactivation)

- **Écran des appareils connectés**  
  Entités : Device, User

### 8. Préférences et paramètres
- **Écran des paramètres** (liste)  
  Entités : UserPreferences (langue, thème, notifications), Consent (géolocalisation)

- **Écran de choix de langue**  
  Entités : UserPreferences

- **Écran de gestion des notifications**  
  Entités : UserPreferences (paramètres de notification)

- **Écran de choix du thème**  
  Entités : UserPreferences

- **Écran de confidentialité**  
  Entités : Consent (géolocalisation, données), User

- **Écran de géolocalisation**  
  Entités : Consent, Location (accès)

### 9. Aide et support
- **Écran d’aide** (FAQ)  
  Entités : FAQ (articles)

- **Écran de détail d’une question FAQ**  
  Entités : FAQ

- **Écran de contact support**  
  Entités : SupportTicket, User, Message

- **Écran de signalement d’un problème**  
  Entités : SupportTicket, User, Document (pièces jointes)

### 10. Informations légales
- **Écran CGU**  
  Entités : LegalDocument (CGU)

- **Écran politique de confidentialité**  
  Entités : LegalDocument

- **Écran mentions légales**  
  Entités : LegalDocument

- **Écran « À propos »**  
  Entités : AppInfo (version, crédits)

---

## 🛠️ Profil **Prestataire**

### 1. Authentification & gestion de compte
- **Écran de bienvenue / onboarding** (spécifique)  
  Entités : Aucune

- **Écran de connexion**  
  Entités : User, OTP

- **Écran d’inscription prestataire**  
  Entités : User, Provider (création), Document (justificatifs éventuels)

- **Écran de vérification OTP**  
  Entités : User, OTP

- **Écran de réinitialisation de mot de passe**  
  Entités : User, OTP

- **Écran de déconnexion**  
  Entités : Session

### 2. Configuration du profil professionnel
- **Écran d’accueil après inscription** (guide)  
  Entités : Provider

- **Écran d’édition du profil professionnel**  
  Entités : Provider, User, Document (photo)

- **Écran de gestion des services proposés**  
  Entités : Provider, Service (ou lien ProviderService), ServiceCategory

- **Écran de définition des zones d’intervention**  
  Entités : Provider, Zone (ou Address/Area)

- **Écran de tarifs indicatifs**  
  Entités : Provider, Service, Pricing

- **Écran de gestion des disponibilités**  
  Entités : Provider, Availability

- **Écran de soumission de justificatifs**  
  Entités : Provider, Document, VerificationStatus

- **Écran de statut de vérification**  
  Entités : Provider, VerificationStatus, Document

### 3. Gestion des demandes reçues
- **Tableau de bord des demandes**  
  Entités : ServiceRequest, Client, Provider, Status

- **Écran de détail d’une demande reçue**  
  Entités : ServiceRequest, Client, Address, Message, Status

- **Écran de confirmation d’acceptation/refus** (modale)  
  Entités : ServiceRequest (changement de statut), Provider

- **Écran de refus avec motif**  
  Entités : ServiceRequest, RefusalReason (optionnel)

### 4. Suivi des missions
- **Écran des missions en cours**  
  Entités : ServiceRequest, Client, Status

- **Écran de détail d’une mission**  
  Entités : ServiceRequest, Client, Address, Message, Status

- **Écran d’historique des missions terminées**  
  Entités : ServiceRequest, Client, Review

- **Écran de détail d’une mission passée**  
  Entités : ServiceRequest, Client, Review

### 5. Messagerie
- **Écran de liste des conversations**  
  Entités : Conversation, ServiceRequest, Client, Provider, Message

- **Écran de conversation**  
  Entités : Message, ServiceRequest, Client, Provider, Document

### 6. Consultation des avis
- **Écran des avis reçus**  
  Entités : Review, Client, ServiceRequest

- **Écran de détail d’un avis**  
  Entités : Review, Client, ServiceRequest, éventuellement Response (réponse du prestataire)

### 7. Sécurité du compte
- **Écran de sécurité**  
  Entités : User, Device, OTP

- **Écran de changement de mot de passe**  
  Entités : User

- **Écran de gestion OTP**  
  Entités : User, OTP

- **Écran des appareils connectés**  
  Entités : Device, User

### 8. Préférences et paramètres
- **Écran des paramètres**  
  Entités : UserPreferences, Consent

- **Sous-écrans** (langue, notifications, thème, confidentialité, géolocalisation)  
  Entités : UserPreferences, Consent

### 9. Aide et support
- **Écran d’aide** (FAQ spécifique)  
  Entités : FAQ

- **Écran de contact support**  
  Entités : SupportTicket, User, Message

### 10. Informations légales
- **Écrans CGU, politique, mentions, à propos**  
  Entités : LegalDocument, AppInfo

---

## 🧑‍💼 Profil **Administrateur** (back-office)

- **Écran de connexion admin**  
  Entités : Admin, OTP/2FA

- **Tableau de bord**  
  Entités : User, ServiceRequest, Review, etc. (agrégats)

- **Écran de gestion des utilisateurs** (liste)  
  Entités : User (clients, prestataires), Role

- **Écran de détail d’un utilisateur**  
  Entités : User, Client/Provider, Document, VerificationStatus, ServiceRequest (historique)

- **Écran de validation des prestataires**  
  Entités : Provider, Document, VerificationStatus, Admin (action)

- **Écran de gestion des catégories de services**  
  Entités : ServiceCategory, Admin

- **Écran de modération des avis**  
  Entités : Review, Report, Admin

- **Écran de gestion des signalements**  
  Entités : Report, ServiceRequest, User, Admin

- **Écran de paramètres généraux**  
  Entités : PlatformConfig, Admin

- **Écran des logs d’activité**  
  Entités : Log, Admin

- **Écran d’aide / documentation**  
  Entités : Doc (interne)

---

## 🌐 Écrans transverses / communs (tous profils)

- **Écran de chargement** (splash)  
  Entités : Aucune

- **Écran de démarrage** (choix du profil)  
  Entités : User (si déjà connecté, redirection)

- **Écran d’erreur réseau**  
  Entités : Aucune

- **Écran 404 / page non trouvée**  
  Entités : Aucune

- **Écran d’accès refusé**  
  Entités : User, Role

- **Modales de confirmation**  
  Entités : selon contexte (ex: ServiceRequest pour annulation)

- **Popups de notification**  
  Entités : Notification (message)

- **Écran de notifications** (liste)  
  Entités : Notification, User

- **Sélecteur de langue**  
  Entités : UserPreferences

- **Écran de consentement** (premier lancement)  
  Entités : Consent, User