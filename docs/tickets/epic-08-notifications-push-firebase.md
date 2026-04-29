# Epic 08 — Notifications push (Firebase)

## Objectif
Envoyer des notifications push web (FCM) sur événements clés : message, acceptation, changement statut.

## Tickets

### TCK-0801 — Configuration Firebase Admin (serveur)
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux pouvoir envoyer des push depuis le serveur.
- **Critères d’acceptation** :
  - Firebase Admin configuré via env.
  - Envoi test OK.
- **Tâches techniques** :
  - Adapter `PushNotificationPort` Firebase.
  - Gestion des erreurs.
- **Dépendances** : Epic 00 (env).

### TCK-0802 — Enregistrement du token push côté client
- **Priorité** : Haute
- **User story** : En tant qu’utilisateur, je veux activer les notifications.
- **Critères d’acceptation** :
  - Demande permission.
  - Token enregistré.
- **Tâches techniques** :
  - UI consentement.
  - Table tokens (user_id, token, platform, created_at).
- **Dépendances** : TCK-0801, Epic 02.

### TCK-0803 — Push sur nouveau message
- **Priorité** : Moyenne
- **User story** : En tant qu’utilisateur, je veux être notifié d’un nouveau message.
- **Critères d’acceptation** :
  - Envoi push au destinataire si permission.
- **Tâches techniques** :
  - Hook après `SendMessage`.
  - Payload standardisé.
- **Dépendances** : Epic 06, TCK-0802.

### TCK-0804 — Push sur acceptation/refus
- **Priorité** : Basse
- **User story** : En tant que client, je veux être notifié si on accepte/refuse.
- **Critères d’acceptation** :
  - Push sur transition.
- **Tâches techniques** :
  - Hook après accept/reject.
- **Dépendances** : Epic 05, TCK-0802.

### TCK-0805 — Gestion des tokens invalides
- **Priorité** : Moyenne
- **User story** : En tant qu’équipe, je veux éviter de spammer des tokens morts.
- **Critères d’acceptation** :
  - Suppression/invalidations automatisées.
- **Tâches techniques** :
  - Détection réponses FCM.
  - Nettoyage DB.
- **Dépendances** : TCK-0801.
