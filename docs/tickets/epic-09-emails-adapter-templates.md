# Epic 09 — Emails : adaptateurs (SMTP/Resend) + templates HTML

## Objectif
Mettre en place l’envoi d’emails transactionnels via un port `EmailPort` et deux adaptateurs (SMTP et Resend), sélectionnable par variables d’environnement, avec templates HTML dans `templates/`.

## Tickets

### TCK-0901 — Définir le port EmailPort + modèles de messages
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux un contrat unique d’envoi d’email pour isoler l’infrastructure.
- **Critères d’acceptation** :
  - Interface `EmailPort` définie.
  - Modèle de payload email (to, subject, template, variables).
- **Tâches techniques** :
  - Définir types/DTO.
  - Ajouter tests unitaires basiques.
- **Dépendances** : Epic 00.

### TCK-0902 — Implémenter l’adaptateur SMTP (Mailer)
- **Priorité** : Haute
- **User story** : En tant qu’admin, je veux pouvoir envoyer des emails via SMTP.
- **Critères d’acceptation** :
  - Envoi email de test OK.
  - Gestion des erreurs/logs.
- **Tâches techniques** :
  - Implémenter adapter SMTP.
  - Charger config via env.
- **Dépendances** : TCK-0901.

### TCK-0903 — Implémenter l’adaptateur Resend
- **Priorité** : Haute
- **User story** : En tant qu’admin, je veux pouvoir envoyer des emails via Resend.
- **Critères d’acceptation** :
  - Envoi email de test OK.
  - Gestion des erreurs/logs.
- **Tâches techniques** :
  - Implémenter adapter Resend.
  - Charger `RESEND_API_KEY` via env.
- **Dépendances** : TCK-0901.

### TCK-0904 — Factory de sélection du provider via env
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux choisir SMTP ou Resend sans changer le code.
- **Critères d’acceptation** :
  - Variable `EMAIL_PROVIDER` supportée.
  - Valeur invalide → erreur explicite.
- **Tâches techniques** :
  - Factory `EmailAdapterFactory`.
  - Tests.
- **Dépendances** : TCK-0902, TCK-0903.

### TCK-0905 — Moteur de rendu templates HTML
- **Priorité** : Haute
- **User story** : En tant qu’utilisateur, je veux recevoir de beaux emails cohérents avec la charte.
- **Critères d’acceptation** :
  - Templates HTML dans `src/infrastructure/email/templates/`.
  - Injection de variables (nom, lien, etc.).
- **Tâches techniques** :
  - Choisir stratégie de templating (simple interpolation / moteur).
  - Ajout d’un layout commun (header/footer).
- **Dépendances** : TCK-0901.

### TCK-0906 — Emails transactionnels MVP
- **Priorité** : Moyenne
- **User story** : En tant qu’utilisateur, je veux être informé par email des événements importants.
- **Critères d’acceptation** :
  - Au moins : notification demande acceptée, reset (si activé), mission terminée.
- **Tâches techniques** :
  - Déclencheurs depuis les use cases concernés.
  - Anti-spam : ne pas dupliquer.
- **Dépendances** : Epic 05, Epic 02, TCK-0904, TCK-0905.
