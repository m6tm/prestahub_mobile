# Entités du domaine — Prestahub

Ce document regroupe l'ensemble des entités identifiées dans l'application Prestahub avec leurs attributs déduits de l'analyse fonctionnelle.

---

## Entités principales

### User
Utilisateur de la plateforme (base pour Client, Provider, Admin).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| email | string | Adresse email (optionnel selon mode auth) |
| phone | string | Numéro de téléphone |
| password_hash | string | Mot de passe haché (si auth email) |
| role_id | UUID | Référence vers Role |
| role | enum | Rôle : `client`, `provider`, `admin` (redondant pour requêtes rapides, à synchroniser avec role_id via trigger ou logique applicative) |
| status | enum | Statut : `active`, `suspended`, `deleted` |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |
| deleted_at | datetime | Date de suppression (nullable, pour traçabilité) |
| last_login_at | datetime | Dernière connexion |
| cgu_accepted | boolean | Acceptation des CGU |
| cgu_accepted_at | datetime | Date d'acceptation CGU |

---

### Client
Profil client (hérite/extend User).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique (réf. User) |
| user_id | UUID | Référence vers User |
| first_name | string | Prénom |
| last_name | string | Nom |
| avatar_url | string | URL de la photo de profil |
| default_address_id | UUID | Adresse par défaut |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### Provider
Profil prestataire (hérite/extend User).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique (réf. User) |
| user_id | UUID | Référence vers User |
| business_name | string | Nom commercial |
| description | text | Description de l'activité |
| phone | string | Téléphone de contact professionnel |
| email | string | Email de contact professionnel |
| avatar_url | string | URL de la photo de profil |
| siret | string | SIRET/identifiant professionnel (optionnel) |
| verification_status | enum | Statut : `unverified`, `pending`, `verified`, `rejected` |
| verification_rejection_reason | text | Motif de refus si applicable |
| is_active | boolean | Profil actif/inactif |
| average_rating | decimal | Note moyenne (calculée) |
| reviews_count | integer | Nombre d'avis (calculé) |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### Admin
Profil administrateur (hérite/extend User). Les permissions sont gérées via Role et Permission (RBAC).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique (réf. User) |
| user_id | UUID | Référence vers User |
| department | string | Département (optionnel) |
| created_at | datetime | Date de création |

---

### ServiceCategory
Catégorie de services (ex: plomberie, électricité).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| name | string | Nom de la catégorie |
| slug | string | Slug pour URL |
| description | text | Description |
| icon | string | Icône (nom ou URL) |
| is_active | boolean | Catégorie active/inactive |
| sort_order | integer | Ordre d'affichage |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### Service
Service proposé par un prestataire.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| provider_id | UUID | Référence vers Provider |
| category_id | UUID | Référence vers ServiceCategory |
| name | string | Nom du service |
| description | text | Description |
| pricing_type | enum | Type : `hourly`, `fixed`, `range` |
| price_min | decimal | Prix minimum (si range) |
| price_max | decimal | Prix maximum (si range) |
| price | decimal | Prix fixe (si fixed) |
| is_active | boolean | Service actif/inactif |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### Address
Adresse d'un client (les zones d'intervention des prestataires sont gérées par l'entité Zone).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| user_id | UUID | Référence vers User (client) |
| label | string | Libellé (ex: "Domicile", "Bureau") |
| street | string | Rue |
| city | string | Ville |
| district | string | Quartier |
| landmark | string | Point de repère |
| latitude | decimal | Latitude (optionnel) |
| longitude | decimal | Longitude (optionnel) |
| is_default | boolean | Adresse par défaut |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### Zone
Zone d'intervention d'un prestataire.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| provider_id | UUID | Référence vers Provider |
| name | string | Nom de la zone |
| city | string | Ville |
| districts | json | Liste des quartiers couverts |
| is_active | boolean | Zone active/inactive |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### ServiceRequest
Demande de service (lead).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| client_id | UUID | Référence vers Client |
| provider_id | UUID | Référence vers Provider (si ciblé) |
| category_id | UUID | Référence vers ServiceCategory |
| status | enum | Statut : `draft`, `sent`, `accepted`, `refused`, `scheduled`, `in_progress`, `completed`, `cancelled` |
| title | string | Titre de la demande |
| description | text | Description du besoin |
| address_id | UUID | Référence vers Address |
| urgency | enum | Urgence : `immediate`, `today`, `scheduled` |
| scheduled_date | date | Date planifiée |
| scheduled_time | time | Heure planifiée |
| preferred_slots | json | Créneaux préférés (optionnel, pour MVP un seul créneau suffit) |
| photos | json | Liste des URLs des photos |
| cancellation_reason | text | Motif d'annulation (si applicable) |
| refusal_reason_id | UUID | Référence vers RefusalReason (si refus) |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |
| completed_at | datetime | Date de terminaison |

---

### Status / StatusHistory
Historique des changements de statut d'une demande.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| service_request_id | UUID | Référence vers ServiceRequest |
| status | enum | Statut |
| changed_by | UUID | Utilisateur ayant effectué le changement |
| reason | text | Motif du changement |
| created_at | datetime | Date du changement |

---

### Availability
Disponibilité d'un prestataire.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| provider_id | UUID | Référence vers Provider |
| day_of_week | integer | Jour de la semaine (0-6) |
| start_time | time | Heure de début |
| end_time | time | Heure de fin |
| is_available | boolean | Disponible ou non |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### AvailabilityException
Exception de disponibilité (absence ponctuelle).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| provider_id | UUID | Référence vers Provider |
| date | date | Date de l'exception |
| is_available | boolean | Disponible ou non |
| reason | string | Motif (optionnel) |
| created_at | datetime | Date de création |

---

### Message
Message dans une conversation.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| conversation_id | UUID | Référence vers Conversation |
| sender_id | UUID | Référence vers User (expéditeur) |
| content | text | Contenu du message |
| attachments | json | Liste des pièces jointes (URLs) |
| read_at | datetime | Date de lecture |
| created_at | datetime | Date d'envoi |

---

### Conversation
Conversation entre client et prestataire.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| service_request_id | UUID | Référence vers ServiceRequest |
| client_id | UUID | Référence vers Client |
| provider_id | UUID | Référence vers Provider |
| last_message_at | datetime | Date du dernier message |
| created_at | datetime | Date de création |

---

### Review
Avis sur une mission.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| service_request_id | UUID | Référence vers ServiceRequest |
| client_id | UUID | Référence vers Client (auteur) |
| provider_id | UUID | Référence vers Provider (cible) |
| rating | integer | Note (1-5) |
| comment | text | Commentaire |
| is_visible | boolean | Visible ou masqué (modération) |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### Response
Réponse d'un prestataire à un avis.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| review_id | UUID | Référence vers Review |
| provider_id | UUID | Référence vers Provider |
| content | text | Contenu de la réponse |
| created_at | datetime | Date de création |

---

### Report
Signalement (avis, utilisateur, demande).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| reporter_id | UUID | Référence vers User (signalant) |
| reported_type | enum | Type : `review`, `user`, `service_request` |
| reported_id | UUID | ID de l'élément signalé |
| reason | text | Motif du signalement |
| status | enum | Statut : `pending`, `reviewed`, `resolved`, `dismissed` |
| admin_id | UUID | Référence vers Admin (traitant) |
| resolution | text | Résolution |
| created_at | datetime | Date de création |
| resolved_at | datetime | Date de résolution |

---

### RefusalReason
Motif de refus d'une demande (prédéfini).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| label | string | Libellé du motif |
| is_active | boolean | Motif actif/inactif |
| sort_order | integer | Ordre d'affichage |

---

## Entités d'authentification et sécurité

### Session
Session utilisateur.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| user_id | UUID | Référence vers User |
| token | string | Token de session |
| ip_address | string | Adresse IP |
| user_agent | string | User agent |
| expires_at | datetime | Date d'expiration |
| created_at | datetime | Date de création |

---

### OTP
Code OTP pour authentification.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| user_id | UUID | Référence vers User (optionnel) |
| phone | string | Numéro de téléphone |
| email | string | Adresse email |
| code | string | Code OTP |
| type | enum | Type : `login`, `register`, `reset_password`, `verify` |
| attempts | integer | Nombre de tentatives |
| is_used | boolean | Code utilisé |
| expires_at | datetime | Date d'expiration |
| created_at | datetime | Date de création |

---

### Device
Appareil connecté.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| user_id | UUID | Référence vers User |
| device_name | string | Nom de l'appareil |
| device_type | string | Type (mobile, desktop, etc.) |
| ip_address | string | Adresse IP |
| user_agent | string | User agent |
| last_active_at | datetime | Dernière activité |
| push_token | string | Token push FCM (optionnel) |
| is_active | boolean | Appareil actif |
| created_at | datetime | Date de création |

---

## Entités de configuration utilisateur

### UserPreferences
Préférences utilisateur.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| user_id | UUID | Référence vers User |
| language | string | Langue (ex: `fr`, `en`) |
| theme | enum | Thème : `light`, `dark`, `system` |
| notifications_enabled | boolean | Notifications activées |
| push_notifications | boolean | Notifications push |
| email_notifications | boolean | Notifications email |
| sms_notifications | boolean | Notifications SMS |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### Consent
Consentement utilisateur.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| user_id | UUID | Référence vers User |
| type | enum | Type : `geolocation`, `marketing`, `analytics` |
| granted | boolean | Consentement accordé |
| granted_at | datetime | Date d'accord |
| revoked_at | datetime | Date de révocation |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

## Entités de support

### FAQ
Question fréquente.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| category | string | Catégorie |
| question | string | Question |
| answer | text | Réponse |
| target_role | enum | Cible : `client`, `provider`, `all` |
| sort_order | integer | Ordre d'affichage |
| is_active | boolean | FAQ active |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### SupportTicket
Ticket de support.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| user_id | UUID | Référence vers User |
| subject | string | Sujet |
| description | text | Description |
| status | enum | Statut : `open`, `in_progress`, `resolved`, `closed` |
| priority | enum | Priorité : `low`, `medium`, `high` |
| attachments | json | Pièces jointes (URLs) |
| assigned_to | UUID | Référence vers Admin (assigné) |
| created_at | datetime | Date de création |
| resolved_at | datetime | Date de résolution |
| updated_at | datetime | Date de dernière modification |

---

## Entités de documentation

### Document
Document (justificatif, pièce jointe).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| owner_type | enum | Type propriétaire : `user`, `provider`, `service_request` |
| owner_id | UUID | ID du propriétaire |
| type | enum | Type : `id_card`, `business_registration`, `certification`, `photo`, `other` |
| name | string | Nom du fichier |
| url | string | URL du fichier |
| size | integer | Taille en bytes |
| mime_type | string | Type MIME |
| verification_status | enum | Statut : `pending`, `verified`, `rejected` |
| created_at | datetime | Date de création |

---

### LegalDocument
Document légal (CGU, politique, mentions).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| type | enum | Type : `terms`, `privacy`, `legal_notices` |
| title | string | Titre |
| content | text | Contenu |
| version | string | Version |
| effective_date | date | Date d'entrée en vigueur |
| is_active | boolean | Document actif |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### AppInfo
Informations sur l'application.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| version | string | Version de l'application |
| build_number | integer | Numéro de build |
| credits | text | Crédits |
| release_notes | text | Notes de version |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

## Entités d'administration

### PlatformConfig
Configuration de la plateforme.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| key | string | Clé de configuration |
| value | json | Valeur |
| description | text | Description |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### Log
Journal d'activité.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| actor_id | UUID | Référence vers User (acteur) |
| action | string | Action effectuée |
| entity_type | string | Type d'entité concernée |
| entity_id | UUID | ID de l'entité concernée |
| details | json | Détails de l'action |
| ip_address | string | Adresse IP |
| created_at | datetime | Date de création |

---

### Notification
Notification utilisateur.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| user_id | UUID | Référence vers User |
| type | string | Type de notification |
| title | string | Titre |
| content | text | Contenu |
| data | json | Données supplémentaires |
| is_read | boolean | Notification lue |
| read_at | datetime | Date de lecture |
| created_at | datetime | Date de création |

---

### VerificationStatus
Statut de vérification (historique).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| provider_id | UUID | Référence vers Provider |
| status | enum | Statut : `unverified`, `pending`, `verified`, `rejected` |
| admin_id | UUID | Référence vers Admin (validateur) |
| reason | text | Motif (si rejet) |
| created_at | datetime | Date de création |

---

## Entités transverses

### Gallery
Galerie de photos d'un prestataire.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| provider_id | UUID | Référence vers Provider |
| url | string | URL de l'image |
| caption | string | Légende (optionnel) |
| sort_order | integer | Ordre d'affichage |
| created_at | datetime | Date de création |

---

### Role
Rôle utilisateur pour le système RBAC (Role-Based Access Control).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| name | string | Nom du rôle (ex: `client`, `provider`, `admin`, `super_admin`) |
| slug | string | Slug pour référence (ex: `client`, `provider`, `admin`) |
| description | text | Description du rôle |
| is_system | boolean | Rôle système (non modifiable/supprimable) |
| created_at | datetime | Date de création |
| updated_at | datetime | Date de dernière modification |

---

### Permission
Permission pour le système RBAC.

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| name | string | Nom de la permission (ex: `users.read`, `users.write`, `reviews.moderate`) |
| description | text | Description de la permission |
| resource | string | Ressource concernée (ex: `users`, `reviews`, `categories`) |
| action | string | Action (ex: `read`, `write`, `delete`, `moderate`) |
| created_at | datetime | Date de création |

---

### RolePermission
Association entre Role et Permission (relation plusieurs-à-plusieurs).

| Attribut | Type | Description |
|----------|------|-------------|
| id | UUID | Identifiant unique |
| role_id | UUID | Référence vers Role |
| permission_id | UUID | Référence vers Permission |
| created_at | datetime | Date de création |

---

## Relations principales

```
User (1) ─── (1) Client
User (1) ─── (1) Provider
User (1) ─── (1) Admin
User (N) ─── (1) Role

User (1) ─── (N) Address
User (1) ─── (N) Device
User (1) ─── (1) UserPreferences
User (1) ─── (N) Consent
User (1) ─── (N) Notification
User (1) ─── (N) Session
User (1) ─── (N) OTP
User (1) ─── (N) Document (via owner_type='user' et owner_id)

Provider (1) ─── (N) Service
Provider (1) ─── (N) Zone
Provider (1) ─── (N) Availability
Provider (1) ─── (N) AvailabilityException
Provider (1) ─── (N) Document
Provider (1) ─── (N) Gallery
Provider (1) ─── (N) VerificationStatus

ServiceCategory (1) ─── (N) Service
ServiceCategory (1) ─── (N) ServiceRequest

Client (1) ─── (N) ServiceRequest
Client (N) ─── (1) Address (via default_address_id)
Provider (1) ─── (N) ServiceRequest

ServiceRequest (N) ─── (1) Address (via address_id)
ServiceRequest (N) ─── (1) RefusalReason (via refusal_reason_id)
ServiceRequest (1) ─── (1) Conversation
ServiceRequest (1) ─── (N) StatusHistory
ServiceRequest (1) ─── (N) Document
ServiceRequest (1) ─── (0..1) Review

StatusHistory (N) ─── (1) User (via changed_by)

Conversation (N) ─── (1) Client (via client_id)
Conversation (N) ─── (1) Provider (via provider_id)
Conversation (1) ─── (N) Message

Message (N) ─── (1) User (via sender_id)

Review (N) ─── (1) Client (via client_id)
Review (N) ─── (1) Provider (via provider_id)
Review (1) ─── (0..1) Response
Review (1) ─── (N) Report

Response (N) ─── (1) Provider (via provider_id)

Report (N) ─── (1) User (via reporter_id)
Report (N) ─── (1) Admin (via admin_id)

SupportTicket (N) ─── (1) User (via user_id)
SupportTicket (N) ─── (1) Admin (via assigned_to)

Log (N) ─── (1) User (via actor_id)

VerificationStatus (N) ─── (1) Admin (via admin_id)

Role (N) ─── (N) Permission (via RolePermission)
```

---

## Énumérations

### UserRole (enum ou référence vers Role)
- `client`
- `provider`
- `admin`
- `super_admin`

### UserStatus
- `active`
- `suspended`
- `deleted`

### VerificationStatus
- `unverified`
- `pending`
- `verified`
- `rejected`

### ServiceRequestStatus
- `draft`
- `sent`
- `accepted`
- `refused`
- `scheduled`
- `in_progress`
- `completed`
- `cancelled`

### Urgency
- `immediate`
- `today`
- `scheduled`

### PricingType
- `hourly`
- `fixed`
- `range`

### Theme
- `light`
- `dark`
- `system`

### ConsentType
- `geolocation`
- `marketing`
- `analytics`

### ReportType
- `review`
- `user`
- `service_request`

### ReportStatus
- `pending`
- `reviewed`
- `resolved`
- `dismissed`

### DocumentType
- `id_card`
- `business_registration`
- `certification`
- `photo`
- `other`

### LegalDocumentType
- `terms`
- `privacy`
- `legal_notices`

### OTPType
- `login`
- `register`
- `reset_password`
- `verify`

### TargetRole
- `client`
- `provider`
- `all`
