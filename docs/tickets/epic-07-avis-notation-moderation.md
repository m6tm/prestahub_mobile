# Epic 07 — Avis & notation

## Objectif
Permettre au client de noter un prestataire après une mission terminée, avec modération et affichage sur la fiche prestataire.

## Tickets

### TCK-0701 — Modèle Avis + contraintes
- **Priorité** : Haute
- **User story** : En tant que plateforme, je veux lier un avis à une mission terminée.
- **Critères d’acceptation** :
  - Un avis par mission.
  - Note 1..5 + commentaire.
  - Interdiction si mission non terminée.
- **Tâches techniques** :
  - Table Supabase + index.
  - Enforcement via use case + RLS si possible.
- **Dépendances** : Epic 05.

### TCK-0702 — Créer un avis (UI + endpoint)
- **Priorité** : Haute
- **User story** : En tant que client, je veux laisser un avis.
- **Critères d’acceptation** :
  - Formulaire note/commentaire.
  - Confirmation et affichage.
- **Tâches techniques** :
  - Use case `CreateReview`.
  - Endpoint `POST /reviews`.
- **Dépendances** : TCK-0701.

### TCK-0703 — Afficher avis sur fiche prestataire
- **Priorité** : Moyenne
- **User story** : En tant que client, je veux lire les avis.
- **Critères d’acceptation** :
  - Liste paginée.
  - Note moyenne affichée.
- **Tâches techniques** :
  - Endpoint `GET /providers/{id}/reviews`.
  - Calcul moyenne (view SQL ou agrégation).
- **Dépendances** : TCK-0701, Epic 03.

### TCK-0704 — Signalement d’avis
- **Priorité** : Basse
- **User story** : En tant qu’utilisateur, je veux signaler un avis abusif.
- **Critères d’acceptation** :
  - Bouton signaler + motif.
  - Création ticket de modération.
- **Tâches techniques** :
  - Table `review_reports`.
  - Endpoint `POST /reviews/{id}/report`.
- **Dépendances** : TCK-0703.

### TCK-0705 — Modération avis (admin)
- **Priorité** : Moyenne
- **User story** : En tant qu’admin, je veux masquer/supprimer un avis.
- **Critères d’acceptation** :
  - Avis masqué n’apparaît plus publiquement.
  - Traçabilité action admin.
- **Tâches techniques** :
  - Endpoint admin.
  - RLS + guard admin.
- **Dépendances** : Epic 10 (admin) ou Epic 02 (rôle admin).
