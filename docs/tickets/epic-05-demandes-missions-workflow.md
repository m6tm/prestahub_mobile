# Epic 05 — Demandes de service & missions (workflow)

## Objectif
Permettre au client de créer une demande, au prestataire de l’accepter/refuser, puis de suivre une mission avec des statuts jusqu’à la clôture.

## Tickets

### TCK-0501 — Modèle DemandeService + statuts
- **Priorité** : Haute
- **User story** : En tant que plateforme, je veux un modèle de demande structuré.
- **Critères d’acceptation** :
  - Champs : catégorie, description, adresse/repère, créneaux, urgence, photos optionnelles.
  - Statuts : envoyée/acceptée/refusée/annulée (min).
- **Tâches techniques** :
  - Entité/agrégat domaine + validations.
  - Table Supabase + RLS.
- **Dépendances** : Epic 02, Epic 03.

### TCK-0502 — Création de demande (UI + endpoint)
- **Priorité** : Haute
- **User story** : En tant que client, je veux créer une demande vers un prestataire.
- **Critères d’acceptation** :
  - Formulaire + validation.
  - Demande persistée et visible dans l’historique.
- **Tâches techniques** :
  - Endpoint `POST /requests`.
  - Use case `CreateRequest`.
- **Dépendances** : TCK-0501.

### TCK-0503 — Listing demandes côté client
- **Priorité** : Moyenne
- **User story** : En tant que client, je veux voir mes demandes.
- **Critères d’acceptation** :
  - Liste paginée.
  - Détail demande accessible.
- **Tâches techniques** :
  - Endpoint `GET /requests` (scopé user).
  - Page historique.
- **Dépendances** : TCK-0502.

### TCK-0504 — Réception et gestion demandes côté prestataire
- **Priorité** : Haute
- **User story** : En tant que prestataire, je veux voir les demandes reçues.
- **Critères d’acceptation** :
  - Liste des demandes adressées.
  - Détail + actions.
- **Tâches techniques** :
  - Endpoint `GET /provider/requests`.
  - RLS + contrôles d’accès.
- **Dépendances** : TCK-0502.

### TCK-0505 — Acceptation / refus de demande
- **Priorité** : Haute
- **User story** : En tant que prestataire, je veux accepter/refuser.
- **Critères d’acceptation** :
  - Transition d’état contrôlée.
  - Historique des changements.
- **Tâches techniques** :
  - Use cases `AcceptRequest`, `RejectRequest`.
  - Endpoint `POST /requests/{id}/accept` et `.../reject`.
- **Dépendances** : TCK-0504.

### TCK-0506 — Modèle Mission + statuts
- **Priorité** : Haute
- **User story** : En tant que plateforme, je veux une mission rattachée à une demande acceptée.
- **Critères d’acceptation** :
  - Création mission à l’acceptation.
  - Statuts : planifiée/en cours/terminée/annulée.
- **Tâches techniques** :
  - Entité Mission + règles transitions.
  - Table Supabase + index.
- **Dépendances** : TCK-0505.

### TCK-0507 — Mise à jour des statuts de mission
- **Priorité** : Haute
- **User story** : En tant que prestataire, je veux mettre à jour l’avancement.
- **Critères d’acceptation** :
  - Seules transitions autorisées.
  - Traçabilité.
- **Tâches techniques** :
  - Endpoints `POST /missions/{id}/start`, `.../complete`, `.../cancel`.
  - Guards rôle.
- **Dépendances** : TCK-0506.

### TCK-0508 — Annulation par le client (règles)
- **Priorité** : Moyenne
- **User story** : En tant que client, je veux annuler selon conditions.
- **Critères d’acceptation** :
  - Annulation avant acceptation toujours possible.
  - Après acceptation : règles définies.
- **Tâches techniques** :
  - Use case `CancelRequest`.
  - Endpoint `POST /requests/{id}/cancel`.
- **Dépendances** : TCK-0505.

### TCK-0509 — Upload photos de demande (Supabase Storage)
- **Priorité** : Basse
- **User story** : En tant que client, je veux joindre des photos.
- **Critères d’acceptation** :
  - Upload multiples.
  - Liens stockés avec la demande.
- **Tâches techniques** :
  - Bucket + policies.
  - UI upload.
- **Dépendances** : Epic 00 (Storage), TCK-0502.
