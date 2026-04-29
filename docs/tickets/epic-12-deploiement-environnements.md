# Epic 12 — Déploiement, environnements & release

## Objectif
Industrialiser le déploiement sur Vercel (dev/staging/prod), assurer la configuration des variables d’environnement et la stratégie de release.

## Tickets

### TCK-1201 — Environnements Vercel (dev/staging/prod)
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux séparer les environnements.
- **Critères d’acceptation** :
  - 3 environnements configurés.
  - Variables dédiées.
- **Tâches techniques** :
  - Config Vercel.
  - Validation env.
- **Dépendances** : Epic 00.

### TCK-1202 — Stratégie de migrations Supabase
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux versionner la DB.
- **Critères d’acceptation** :
  - Scripts migrations versionnés.
  - Procédure appliquée sur staging/prod.
- **Tâches techniques** :
  - Choisir outil/process.
  - Documenter.
- **Dépendances** : Epics qui créent des tables.

### TCK-1203 — Vérification configuration des services externes
- **Priorité** : Moyenne
- **User story** : En tant qu’équipe, je veux éviter les mises en prod cassées.
- **Critères d’acceptation** :
  - Checklist : Supabase, Firebase, SMTP/Resend, OSM.
- **Tâches techniques** :
  - Script/endpoint de healthcheck minimal.
- **Dépendances** : Epics 08/09.

### TCK-1204 — Release notes (process)
- **Priorité** : Basse
- **User story** : En tant qu’équipe, je veux tracer les livraisons.
- **Critères d’acceptation** :
  - Template de release notes défini.
- **Tâches techniques** :
  - Définir le process.
- **Dépendances** : Aucune.
