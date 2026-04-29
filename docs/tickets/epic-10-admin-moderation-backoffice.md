# Epic 10 — Administration & modération (back-office)

## Objectif
Fournir un back-office (web) pour gérer catégories, utilisateurs, suspensions, modération des avis et consultation des signalements.

## Tickets

### TCK-1001 — Accès admin (guard + UI)
- **Priorité** : Haute
- **User story** : En tant qu’admin, je veux accéder à un espace protégé.
- **Critères d’acceptation** :
  - Routes admin protégées.
  - Seul rôle admin autorisé.
- **Tâches techniques** :
  - Guard côté server + côté UI.
  - Page login/accès.
- **Dépendances** : Epic 02 (rôles).

### TCK-1002 — Gestion catégories/services
- **Priorité** : Haute
- **User story** : En tant qu’admin, je veux créer/activer/désactiver des catégories.
- **Critères d’acceptation** :
  - CRUD catégories.
  - Activation/désactivation visible côté recherche.
- **Tâches techniques** :
  - Endpoints admin.
  - UI tableau.
- **Dépendances** : TCK-1001, Epic 03.

### TCK-1003 — Gestion utilisateurs (liste, suspension)
- **Priorité** : Haute
- **User story** : En tant qu’admin, je veux suspendre un utilisateur.
- **Critères d’acceptation** :
  - Recherche utilisateur.
  - Suspension/désuspension.
- **Tâches techniques** :
  - Endpoints admin.
  - Audit log.
- **Dépendances** : TCK-1001, Epic 02.

### TCK-1004 — Modération avis (masquer/supprimer)
- **Priorité** : Moyenne
- **User story** : En tant qu’admin, je veux traiter les abus.
- **Critères d’acceptation** :
  - Liste avis, action masquer.
  - Avis masqué non visible sur profil.
- **Tâches techniques** :
  - Endpoints + RLS.
  - UI modération.
- **Dépendances** : Epic 07, TCK-1001.

### TCK-1005 — Traitement des signalements
- **Priorité** : Basse
- **User story** : En tant qu’admin, je veux consulter les signalements.
- **Critères d’acceptation** :
  - Liste des reports, statut (ouvert/clos).
- **Tâches techniques** :
  - Table reports.
  - UI.
- **Dépendances** : Epic 07, TCK-1001.

### TCK-1006 — Dashboard admin (KPI basiques)
- **Priorité** : Basse
- **User story** : En tant qu’admin, je veux voir l’activité.
- **Critères d’acceptation** :
  - KPIs : nb demandes, nb missions, nouveaux utilisateurs.
- **Tâches techniques** :
  - Requêtes agrégées.
  - UI.
- **Dépendances** : TCK-1001.
