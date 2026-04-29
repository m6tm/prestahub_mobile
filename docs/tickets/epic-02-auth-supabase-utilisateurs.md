# Epic 02 — Authentification Supabase & gestion utilisateurs

## Objectif
Permettre l’inscription/connexion, la gestion de session, la gestion des rôles (client/prestataire/admin) et les profils utilisateurs.

## Tickets

### TCK-0201 — Auth Supabase : inscription/connexion
- **Priorité** : Haute
- **User story** : En tant qu’utilisateur, je veux créer un compte et me connecter pour accéder aux fonctionnalités.
- **Critères d’acceptation** :
  - Inscription et connexion fonctionnelles.
  - Gestion de session stable (refresh, logout).
  - Affichage des erreurs utilisateur-friendly.
- **Tâches techniques** :
  - Intégrer Supabase Auth côté client.
  - Mettre en place callbacks/redirects SvelteKit.
- **Dépendances** : Epic 00 (Supabase + env).

### TCK-0202 — Gestion de session côté serveur (SvelteKit)
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux sécuriser les endpoints via la session.
- **Critères d’acceptation** :
  - Endpoints protégés refusent sans session.
  - Session accessible côté server pour autorisations.
- **Tâches techniques** :
  - Helpers server pour lire/valider session.
  - Stratégie cookies HTTPOnly si retenue.
- **Dépendances** : TCK-0201.

### TCK-0203 — Modèle utilisateur + rôles
- **Priorité** : Haute
- **User story** : En tant que plateforme, je veux distinguer client/prestataire/admin.
- **Critères d’acceptation** :
  - Stockage du rôle.
  - Gardes côté UI et côté endpoints.
- **Tâches techniques** :
  - Table/profil utilisateur (Supabase) + RLS.
  - Middleware/guard d’autorisation.
- **Dépendances** : TCK-0202.

### TCK-0204 — Profil utilisateur (édition)
- **Priorité** : Moyenne
- **User story** : En tant qu’utilisateur, je veux éditer mes infos de base.
- **Critères d’acceptation** :
  - Page profil accessible.
  - Modification persistée.
- **Tâches techniques** :
  - Use case update profil.
  - Endpoints + validation.
- **Dépendances** : TCK-0203.

### TCK-0205 — Gestion suspension utilisateur (flag)
- **Priorité** : Moyenne
- **User story** : En tant qu’admin, je veux suspendre un compte.
- **Critères d’acceptation** :
  - Un compte suspendu ne peut plus créer de demandes, envoyer de messages, etc.
- **Tâches techniques** :
  - Champ `is_suspended` + enforcement côté endpoints.
  - RLS/politiques si nécessaire.
- **Dépendances** : TCK-0203.
