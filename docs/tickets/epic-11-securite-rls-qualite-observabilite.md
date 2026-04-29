# Epic 11 — Sécurité, RLS, qualité & observabilité

## Objectif
Renforcer la sécurité (RLS Supabase, contrôle d’accès), la qualité (tests) et l’observabilité (logs), afin d’assurer un produit fiable.

## Tickets

### TCK-1101 — Politiques RLS complètes
- **Priorité** : Haute
- **User story** : En tant que plateforme, je veux garantir l’accès aux données uniquement aux bons acteurs.
- **Critères d’acceptation** :
  - Politiques RLS en place pour demandes, missions, messages, avis.
  - Scénarios client/prestataire/admin testés.
- **Tâches techniques** :
  - Définir policies par table.
  - Scripts SQL versionnés.
- **Dépendances** : Epics 05/06/07.

### TCK-1102 — Contrôles d’accès métier côté endpoints
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux une couche d’autorisation métier en plus de RLS.
- **Critères d’acceptation** :
  - Toutes actions sensibles passent par des use cases.
  - Rejets explicites en cas d’accès non autorisé.
- **Tâches techniques** :
  - Guards centralisés.
  - Tests.
- **Dépendances** : Epic 02.

### TCK-1103 — Rate limiting (auth/recherche/endpoints sensibles)
- **Priorité** : Moyenne
- **User story** : En tant que plateforme, je veux limiter l’abus.
- **Critères d’acceptation** :
  - Limites sur auth, recherche, envoi message.
- **Tâches techniques** :
  - Implémenter stratégie (edge/serverless compatible).
- **Dépendances** : Epic 00.

### TCK-1104 — Tests unitaires domaine/use cases
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux sécuriser les règles métiers.
- **Critères d’acceptation** :
  - Couverture des transitions (accept/refuse/cancel/complete).
- **Tâches techniques** :
  - Tests par use case.
  - Mocks ports.
- **Dépendances** : Epics 05/07.

### TCK-1105 — Tests d’intégration adaptateurs (Supabase/Email/Push)
- **Priorité** : Moyenne
- **User story** : En tant qu’équipe, je veux valider les intégrations.
- **Critères d’acceptation** :
  - Tests via mocks ou env staging.
- **Tâches techniques** :
  - Harness tests.
- **Dépendances** : Epics 00/08/09.

### TCK-1106 — Observabilité : logs structurés + corrélation
- **Priorité** : Moyenne
- **User story** : En tant qu’équipe, je veux diagnostiquer rapidement.
- **Critères d’acceptation** :
  - Logs par endpoint.
  - Identifiant de corrélation par requête.
- **Tâches techniques** :
  - Middleware logging.
  - Normaliser erreurs.
- **Dépendances** : Epic 00.
