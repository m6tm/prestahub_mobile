# Epic 06 — Messagerie (client ↔ prestataire)

## Objectif
Permettre une conversation liée à une demande/mission, avec notifications et contraintes de sécurité (accès uniquement aux participants).

## Tickets

### TCK-0601 — Modèle Message + Conversation
- **Priorité** : Haute
- **User story** : En tant que plateforme, je veux stocker des messages liés à une demande.
- **Critères d’acceptation** :
  - Messages rattachés à `request_id` (ou `mission_id`).
  - Champs : sender_id, contenu, created_at.
- **Tâches techniques** :
  - Tables Supabase + index.
  - RLS : seuls participants lisent/écrivent.
- **Dépendances** : Epic 05.

### TCK-0602 — UI conversation (liste + envoi)
- **Priorité** : Haute
- **User story** : En tant qu’utilisateur, je veux discuter avec l’autre partie.
- **Critères d’acceptation** :
  - Affichage historique.
  - Envoi message.
  - Scroll/UX mobile.
- **Tâches techniques** :
  - Page conversation dans détail demande.
  - Validation longueur et contenu.
- **Dépendances** : TCK-0601.

### TCK-0603 — Endpoint envoi message (server)
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux centraliser les règles d’envoi.
- **Critères d’acceptation** :
  - Vérification participants.
  - Rejet si compte suspendu.
- **Tâches techniques** :
  - Use case `SendMessage`.
  - Endpoint `POST /messages`.
- **Dépendances** : TCK-0601, Epic 02.

### TCK-0604 — Realtime (option Supabase)
- **Priorité** : Moyenne
- **User story** : En tant qu’utilisateur, je veux voir les nouveaux messages sans refresh.
- **Critères d’acceptation** :
  - Abonnement realtime sur conversation.
- **Tâches techniques** :
  - Intégrer Supabase Realtime.
  - Gestion reconnection.
- **Dépendances** : TCK-0602.

### TCK-0605 — Pièces jointes messages (option)
- **Priorité** : Basse
- **User story** : En tant qu’utilisateur, je veux envoyer une image.
- **Critères d’acceptation** :
  - Upload + message contenant URL.
- **Tâches techniques** :
  - Storage bucket dédié.
  - Validation type/poids.
- **Dépendances** : Epic 00 (Storage), TCK-0603.
