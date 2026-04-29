# Cahier des charges technique — Prestahub

## 1. Objet du document
Ce document décrit les choix techniques, l’architecture cible, les exigences non-fonctionnelles et les conventions de mise en œuvre pour Prestahub.

## 2. Stack technique cible
### 2.1 Application Web (Front + Back)
- **Framework** : Svelte (recommandation d’implémentation : **SvelteKit** pour SSR, routing, endpoints serveur et déploiement Vercel)
- **Type** : application web responsive (mobile-first)
- **API** : endpoints serveur SvelteKit (REST) + accès direct Supabase (selon règles de sécurité)

### 2.1.1 Thème de l’application
La définition du thème UI (design system : couleurs, typographies, tailles responsives, espacements, règles d’accessibilité) est décrite dans :
- [Sélection du thème](selection-theme.md)

### 2.1.2 Styling (TailwindCSS)
- **Framework CSS** : TailwindCSS pour construire l’UI (responsive, états, variants).
- **Thème** : les couleurs/typographies définies dans la documentation de thème doivent être intégrées au système de design (tokens CSS) et consommées via des classes utilitaires.
- **Mode clair/sombre (si activé)** : support via une stratégie de bascule (ex : attribut `data-theme`) et des variantes adaptées.
- **Règle** : éviter le CSS “ad hoc” dans les composants ; privilégier Tailwind + tokens.

### 2.2 Authentification et stockage
- **Auth** : Supabase Auth
  - Email/mot de passe et/ou téléphone OTP selon configuration
  - Gestion des sessions côté SvelteKit (cookies HTTPOnly recommandés)
- **Storage** : Supabase Storage
  - Avatars prestataires
  - Pièces jointes (photos demandes)
  - Éventuels justificatifs (si vérification)

### 2.3 Notifications push
- **Push** : Firebase Cloud Messaging (FCM)
  - Gestion des tokens device (web push)
  - Déclenchement côté serveur (SvelteKit) via SDK Admin
  - Cas d’usage : nouveau message, demande acceptée, rappel de mission

### 2.4 Cartographie
- **Carte** : OpenStreetMap via librairie frontend (ex : Leaflet)
- **Géocodage** :
  - MVP : saisie ville/quartier + point de repère + latitude/longitude optionnelle
  - Évolutif : géocodage via fournisseur compatible OSM (Nominatim ou autre, avec limites et cache)

### 2.5 Hébergement
- **Déploiement** : Vercel
  - Front + endpoints SvelteKit (serverless/edge selon contraintes)
  - Variables d’environnement via Vercel

### 2.6 Emails
- **Principe** : système d’envoi email via **adaptateur** sélectionnable par variables d’environnement
- **Providers** :
  - SMTP (Mailer)
  - Resend
- **Templates** : répertoire `templates/` contenant des modèles **HTML** (emails esthétiques et cohérents avec le thème)

## 3. Architecture logicielle
### 3.1 Style architectural
- **Architecture hexagonale (Ports & Adapters)**
  - Le domaine ne dépend d’aucune infrastructure (Supabase, Firebase, SMTP, Resend, Leaflet, etc.)
  - Les cas d’usage orchestrent le domaine et utilisent des interfaces (ports)
  - Les adaptateurs implémentent les ports pour chaque technologie

### 3.2 Découpage en couches (responsabilités)
- **Domaine**
  - Entités : Utilisateur, Prestataire, ProfilPrestataire, Client, DemandeService, Mission, Avis, Message
  - Value Objects : Localisation, StatutMission, RôleUtilisateur, Identifiants
  - Règles métiers : transitions d’état, contraintes d’avis, permissions
- **Application (Use Cases)**
  - Cas d’usage : créer demande, accepter/refuser, clôturer mission, déposer avis, etc.
  - Transactions et orchestration des ports
- **Ports (Interfaces)**
  - `UserRepositoryPort`, `RequestRepositoryPort`, `MissionRepositoryPort`, `MessageRepositoryPort`
  - `StoragePort`, `EmailPort`, `PushNotificationPort`, `GeoPort`
  - `ClockPort`, `IdGeneratorPort` si nécessaire
- **Adapters (Infrastructure)**
  - Supabase (DB/Auth/Storage)
  - Firebase (push)
  - SMTP Mailer / Resend (emails)
  - OSM (carto côté front, géocodage optionnel côté back)
- **Interface (Web/UI)**
  - Routes/pages SvelteKit
  - Endpoints SvelteKit (controllers)
  - Validation des entrées, mapping DTO → commandes use case

## 4. Structure de projet recommandée
L’objectif est de conserver une séparation nette domaine / application / infrastructure.

Recommandation (exemple) :
- `src/`
  - `domain/`
  - `application/`
  - `ports/`
  - `infrastructure/`
  - `presentation/`
- `src/infrastructure/email/`
  - `smtp/`
  - `resend/`
  - `templates/`

## 5. Données, persistance et sécurité
### 5.1 Base de données
- **Base** : Supabase Postgres
- **Approche** :
  - Tables normalisées pour les agrégats (demandes, missions, avis, messages)
  - Index sur : localisation (si geo), catégories, prestataire_id, status, created_at

### 5.2 Row Level Security (RLS)
- RLS activé par défaut sur les tables sensibles
- Politiques :
  - Un client ne peut lire/écrire que ses demandes/missions
  - Un prestataire ne peut lire/écrire que les demandes/missions qui lui sont adressées/attribuées
  - Les avis sont créés uniquement si mission terminée (enforcement via règles + contrôles serveur)

### 5.3 Accès Supabase
- **Côté client** : accès restreint aux opérations sûres (lecture catalogue, consultation profils publics, etc.)
- **Côté serveur** :
  - Utilisation d’une clé de service uniquement côté serveur si nécessaire
  - Le serveur applique une couche d’autorisation métier en plus des politiques RLS

## 6. API / Endpoints
### 6.1 Style
- Endpoints SvelteKit (REST)
- Validation systématique des payloads (schémas)

### 6.2 Ressources principales (MVP)
- `auth/` : session, profil
- `categories/` : liste
- `providers/` : recherche, détail
- `requests/` : créer, lister, détail, annuler
- `missions/` : changer statut, clôturer
- `messages/` : envoyer, lister
- `reviews/` : créer, lister
- `admin/` : modération, catégories, suspensions (protégé)

## 7. Notifications push (Firebase)
### 7.1 Gestion des tokens
- Stockage des tokens push associés à l’utilisateur
- Rotation/invalidations : suppression des tokens invalides

### 7.2 Événements
- Nouveau message
- Demande acceptée/refusée
- Mission planifiée / rappel

### 7.3 Port et adaptateur
- `PushNotificationPort` : `sendToUser(userId, payload)`
- Adaptateur Firebase Admin : implémentation du port

## 8. Emails
### 8.1 Objectifs
- Confirmation d’inscription (si activé)
- Notifications transactionnelles : demande acceptée, mission terminée, reset

### 8.2 Sélection du provider par variables d’environnement
- Stratégie : une factory choisit l’implémentation de `EmailPort` au démarrage
- Variables recommandées (noms indicatifs) :
  - `EMAIL_PROVIDER` = `smtp` | `resend`
  - `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `SMTP_FROM`
  - `RESEND_API_KEY`, `RESEND_FROM`

### 8.3 Templates HTML
- Répertoire : `src/infrastructure/email/templates/`
- Contraintes :
  - HTML compatible email (table layout si nécessaire)
  - Thème cohérent (couleurs, typo, boutons)
  - Contenu paramétrable (nom, liens, récapitulatif)
- Mécanisme : rendu serveur (templating) avec variables

## 9. Cartographie (OpenStreetMap)
### 9.1 Affichage
- Carte interactive sur recherche et sélection d’adresse
- Marqueurs prestataires / zone de service

### 9.2 Géolocalisation
- Consentement explicite côté navigateur
- Fallback : saisie manuelle (ville/quartier)

## 10. Observabilité et logs
- Logs structurés côté serveur (niveau info/warn/error)
- Traçage minimal :
  - Création demande, acceptation, changement statut
  - Envoi email, envoi push
  - Erreurs Supabase/Firebase

## 11. Exigences non-fonctionnelles
### 11.1 Performance
- Optimisation SSR/CSR (SvelteKit)
- Pagination sur listes (prestataires, demandes, messages)
- Mise en cache du catalogue et paramètres

### 11.2 Sécurité
- Protection XSS/CSRF selon stratégie session
- Contrôle d’accès :
  - vérification du rôle (client/prestataire/admin)
  - règles par ressource
- Taux limite sur endpoints sensibles (auth, recherche)

### 11.3 Qualité
- Tests :
  - unitaires domaine/use cases
  - tests d’intégration adaptateurs (Supabase, email, push) via mocks

## 12. CI/CD (cible)
- Build & lint sur chaque PR
- Déploiement automatique Vercel par branche/environnement
- Variables d’environnement séparées : dev/staging/prod

## 13. Gestion de configuration (env)
- Toutes les clés/URL externes via variables d’environnement
- Aucun secret dans le code

## 14. Risques et points d’attention
- Limitations de géocodage OSM (quota/latence) : prévoir cache et stratégie de fallback
- Complexité des politiques RLS : tester finement les scénarios d’accès
- Web push : compatibilités navigateurs et gestion des permissions

## 15. Annexes — Liste indicative des variables d’environnement
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY` (serveur uniquement)
- `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY` (serveur uniquement)
- `EMAIL_PROVIDER`
- `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `SMTP_FROM`
- `RESEND_API_KEY`, `RESEND_FROM`
- `PUBLIC_APP_URL`
