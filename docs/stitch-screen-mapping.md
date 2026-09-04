# Mapping des 71 écrans visibles Stitch → PrestaHub Flutter

**Projet Stitch** : `PrestaHub - Mobile App` (`13260222690519869227`)  
**Projet Flutter** : `D:/projects/personal/prestahub/mobile`  
**Date du mapping** : 2026-08-21

---

## Résumé exécutif

| Métrique | Valeur |
|---|---|
| Écrans visibles Stitch | 71 |
| Correspondance directe avec un écran Flutter existant | 66 |
| Nouveaux écrans / sous-étapes à créer | 5 |
| Flux fonctionnels couverts | 8 |

Les 5 éléments à créer sont :
1. **Étape "Photos du problème"** dans la création de demande (`d4095137`).
2. **Écran de détail FAQ** (`0147bf56`).
3. **Écran de bienvenue prestataire** (`3998b169`).
4. **Modale/écran de confirmation d'acceptation** de mission prestataire (`431de011`).
5. **Variante login admin** (`e47df3d0`) — à fusionner ou à traiter comme cas du login existant.

---

## Tableau de mapping complet

| # | Stitch ID | Titre / label Stitch | Flux | Écran Flutter existant | Action |
|---|---|---|---|---|---|
| 1 | `12517ec1` | Splash Screen PrestaHub | Transverse | `presentation/splash/splash_screen.dart` | Refonte |
| 2 | `ecfacfc6` | Onboarding - Find Pros | Onboarding | `presentation/onboarding/onboarding_screen.dart` | Refonte |
| 3 | `380be85d` | Onboarding - Book Appointment | Onboarding | `presentation/onboarding/onboarding_screen.dart` | Refonte |
| 4 | `be525636` | Onboarding - Rate & Review | Onboarding | `presentation/onboarding/onboarding_screen.dart` | Refonte |
| 5 | `a0c65e4d` | Login form (inféré) | Auth | `presentation/auth/login/login_screen.dart` | Refonte |
| 6 | `e67ddffa` | Signup Screen | Auth | `presentation/auth/signup/signup_screen.dart` | Refonte |
| 7 | `444e1da8` | OTP Verification Screen | Auth | `presentation/auth/otp_verification/otp_verification_screen.dart` | Refonte |
| 8 | `924dc58b` | Inscription Professionnelle | Auth / Provider | `presentation/auth/signup/professional_signup_form.dart` | Refonte |
| 9 | `1b5d32ce` | Mot de passe oublié | Auth | `presentation/auth/forgot_password/forgot_password_screen.dart` | Refonte |
| 10 | `9de71992` | Create New Password Screen | Auth | `presentation/auth/new_password/new_password_screen.dart` | Refonte |
| 11 | `7f106f42` | Logout Confirmation Modal | Transverse | `presentation/common/widgets/modals/logout_confirmation_modal.dart` | Refonte |
| 12 | `5e8d834a` | Écran d'accueil | Client Home | `presentation/home/home_screen.dart` | Refonte |
| 13 | `ef7aab24` | Category Selection Screen | Discovery | `presentation/discovery/categories/category_selection_screen.dart` | Refonte |
| 14 | `e9db2de7` | Service Provider Search Results | Discovery | `presentation/discovery/search/search_results_screen.dart` | Refonte |
| 15 | `13cceec3` | Filter Modal | Discovery | `presentation/discovery/search/widgets/search_filter_sheet.dart` | Refonte |
| 16 | `9588b6fa` | Provider Detail Profile Screen | Discovery | `presentation/discovery/provider_detail/provider_detail_screen.dart` | Refonte |
| 17 | `456dffc4` | Étape 1 : Catégorie & Description | Requests | `presentation/requests/create/request_create_screen.dart` | Refonte |
| 18 | `e349f23a` | Étape 2 : Adresse & Carte | Requests | `presentation/requests/create/request_create_screen.dart` | Refonte |
| 19 | `d4095137` | Étape 3 : Photos du problème | Requests | `presentation/requests/create/request_create_screen.dart` | **Ajouter une étape photos** |
| 20 | `57ef710b` | Étape 4 : Date & Créneaux | Requests | `presentation/requests/create/request_create_screen.dart` | Refonte |
| 21 | `543d1929` | Request Summary Screen | Requests | `presentation/requests/review/request_review_screen.dart` | Refonte |
| 22 | `7c7e90ad` | Request Confirmation Success | Requests | `presentation/requests/confirmation/request_confirmation_screen.dart` | Refonte |
| 23 | `cd99e3b8` | My Requests List Screen | Requests | `presentation/requests/list/request_list_screen.dart` | Refonte |
| 24 | `5e475c62` | Request Detail Screen | Requests | `presentation/requests/detail/request_detail_screen.dart` | Refonte |
| 25 | `53e4891b` | Mission History Screen | Requests | `presentation/requests/history/mission_history_screen.dart` | Refonte |
| 26 | `6f00c384` | Past Mission Detail Screen | Requests | `presentation/requests/detail/mission_detail_screen.dart` | Refonte |
| 27 | `66629f69` | Noter la mission | Reviews | `presentation/reviews/mission_review_screen.dart` | Refonte |
| 28 | `039cd3a9` | Report Review Screen | Reviews | `presentation/reviews/report_review_screen.dart` | Refonte |
| 29 | `7e0f5a8e` | Conversations List Screen | Messages | `presentation/messages/list/conversation_list_screen.dart` | Refonte |
| 30 | `ee2c8f63` | Chat Conversation Screen | Messages | `presentation/messages/conversation/conversation_screen.dart` | Refonte |
| 31 | `61b3d46c` | In-Progress Call Screen | Messages | `presentation/messages/call/call_screen.dart` | Refonte |
| 32 | `a2cd27fa` | Profil Client | Settings / Profile | `presentation/settings/profile/profile_screen.dart` | Refonte |
| 33 | `49aebf41` | Modifier mon profil | Settings / Profile | `presentation/settings/profile/profile_edit_screen.dart` | Refonte |
| 34 | `193acdf3` | Gestion des adresses | Settings / Profile | `presentation/settings/profile/addresses_screen.dart` | Refonte |
| 35 | `f424351d` | Ajouter une adresse | Settings / Profile | `presentation/settings/profile/address_edit_screen.dart` | Refonte |
| 36 | `cf6f124d` | Sécurité du compte | Settings / Security | `presentation/settings/security/security_screen.dart` | Refonte |
| 37 | `75cc9260` | Changer le mot de passe | Settings / Security | `presentation/settings/security/change_password_screen.dart` | Refonte |
| 38 | `4cc3eb5d` | Double authentification | Settings / Security | `presentation/settings/security/otp_settings_screen.dart` | Refonte |
| 39 | `23d6acb0` | Appareils connectés | Settings / Security | `presentation/settings/security/connected_devices_screen.dart` | Refonte |
| 40 | `a0aefcb0` | Paramètres PrestaHub | Settings | `presentation/settings/settings_screen.dart` | Refonte |
| 41 | `19ac9242` | Choix de la langue | Settings | `presentation/settings/preferences/language_screen.dart` | Refonte |
| 42 | `f32356a4` | Gestion des Notifications | Settings | `presentation/settings/preferences/notifications_screen.dart` | Refonte |
| 43 | `07fa4dc0` | Choix du Thème | Settings | `presentation/settings/preferences/theme_screen.dart` | Refonte |
| 44 | `d3f1dee4` | Confidentialité & Consentements | Settings | `presentation/settings/preferences/privacy_screen.dart` | Refonte |
| 45 | `326c1aa9` | Géolocalisation PrestaHub | Settings | `presentation/settings/preferences/geolocation_screen.dart` | Refonte |
| 46 | `1725add1` | Aide & Support FAQ | Settings / Support | `presentation/settings/support/help_screen.dart` | Refonte |
| 47 | `0147bf56` | Détail Question FAQ | Settings / Support | — | **Nouvel écran** |
| 48 | `31c82cc7` | Contacter le support | Settings / Support | `presentation/settings/support/contact_support_screen.dart` | Refonte |
| 49 | `3c9c84bc` | Signaler un problème | Settings / Support | `presentation/settings/support/report_issue_screen.dart` | Refonte |
| 50 | `ba0ca065` | Politique de confidentialité | Legal | `presentation/settings/legal/privacy_policy_screen.dart` | Refonte |
| 51 | `daf1898c` | Conditions Générales d'Utilisation | Legal | `presentation/settings/legal/terms_screen.dart` | Refonte |
| 52 | `4a34d805` | Mentions légales | Legal | `presentation/settings/legal/legal_mentions_screen.dart` | Refonte |
| 53 | `33f93d86` | À propos de PrestaHub | Legal | `presentation/settings/legal/about_screen.dart` | Refonte |
| 54 | `3998b169` | Bienvenue Prestataire | Provider Onboarding | — | **Nouvel écran** |
| 55 | `3cb89418` | Guide de configuration Prestataire | Provider Setup | `presentation/provider/profile_setup/provider_setup_guide_screen.dart` | Refonte |
| 56 | `8dba766c` | Édition du profil professionnel | Provider Setup | `presentation/provider/profile_setup/provider_profile_edit_screen.dart` | Refonte |
| 57 | `13b4bdef` | Gestion des Services | Provider Setup | `presentation/provider/profile_setup/provider_services_screen.dart` | Refonte |
| 58 | `22fac6c1` | Ma zone d'intervention | Provider Setup | `presentation/provider/profile_setup/provider_zones_screen.dart` | Refonte |
| 59 | `c84f48a0` | Mes Tarifs | Provider Setup | `presentation/provider/profile_setup/provider_pricing_screen.dart` | Refonte |
| 60 | `f32fd1f2` | Gestion des disponibilités | Provider Setup | `presentation/provider/profile_setup/provider_availability_screen.dart` | Refonte |
| 61 | `02585879` | Soumission de justificatifs | Provider Setup | `presentation/provider/profile_setup/provider_documents_screen.dart` | Refonte |
| 62 | `f5455fdb` | Statut de vérification | Provider Setup | `presentation/provider/profile_setup/provider_verification_status_screen.dart` | Refonte |
| 63 | `4904714d` | Tableau de bord des demandes (Prestataire) | Provider Ops | `presentation/provider/missions/provider_requests_screen.dart` | Refonte |
| 64 | `8a2d2715` | Détail d'une demande (Prestataire) | Provider Ops | `presentation/provider/missions/provider_request_detail_screen.dart` | Refonte |
| 65 | `431de011` | Confirmation d'acceptation | Provider Ops | — | **Nouvelle modale / écran** |
| 66 | `5cc297f2` | Motif de refus (Prestataire) | Provider Ops | `presentation/provider/missions/provider_refusal_screen.dart` | Refonte |
| 67 | `201cd770` | Missions actives (Prestataire) | Provider Ops | `presentation/provider/missions/provider_missions_screen.dart` | Refonte |
| 68 | `33c63c0c` | Détail de la mission (Prestataire) | Provider Ops | `presentation/provider/missions/provider_mission_detail_screen.dart` | Refonte |
| 69 | `532f66e7` | Liste des Avis Reçus (Prestataire) | Provider Reviews | `presentation/provider/reviews/provider_reviews_screen.dart` | Refonte |
| 70 | `095d6c40` | Détail de l'avis (Réponse) | Provider Reviews | `presentation/provider/reviews/provider_review_detail_screen.dart` | Refonte |
| 71 | `e47df3d0` | Login Admin PrestaHub | Admin | `presentation/auth/login/login_screen.dart` | **Variante admin** |

---

## Regroupement par flux fonctionnel

### 1. Onboarding & Auth (11 écrans)
`12517ec1`, `ecfacfc6`, `380be85d`, `be525636`, `a0c65e4d`, `e67ddffa`, `444e1da8`, `924dc58b`, `1b5d32ce`, `9de71992`, `7f106f42`

Tous les écrans existent déjà. Le login admin (`e47df3d0`) peut être géré comme une variante du login existant.

### 2. Client - Home & Discovery (5 écrans)
`5e8d834a`, `ef7aab24`, `e9db2de7`, `13cceec3`, `9588b6fa`

Tous existent déjà.

### 3. Client - Demandes & Missions (10 écrans)
`456dffc4`, `e349f23a`, `d4095137`, `57ef710b`, `543d1929`, `7c7e90ad`, `cd99e3b8`, `5e475c62`, `53e4891b`, `6f00c384`

**À créer** : l'étape "Photos du problème" (`d4095137`) dans le formulaire de création de demande.

### 4. Client - Reviews (2 écrans)
`66629f69`, `039cd3a9`

Tous existent déjà.

### 5. Messages (3 écrans)
`7e0f5a8e`, `ee2c8f63`, `61b3d46c`

Tous existent déjà.

### 6. Settings, Profil, Support & Legal (16 écrans)
`a2cd27fa`, `49aebf41`, `193acdf3`, `f424351d`, `cf6f124d`, `75cc9260`, `4cc3eb5d`, `23d6acb0`, `a0aefcb0`, `19ac9242`, `f32356a4`, `07fa4dc0`, `d3f1dee4`, `326c1aa9`, `1725add1`, `0147bf56`, `31c82cc7`, `3c9c84bc`, `ba0ca065`, `daf1898c`, `4a34d805`, `33f93d86`

**À créer** : écran de détail FAQ (`0147bf56`).

### 7. Provider - Onboarding & Setup (9 écrans)
`3998b169`, `3cb89418`, `8dba766c`, `13b4bdef`, `22fac6c1`, `c84f48a0`, `f32fd1f2`, `02585879`, `f5455fdb`

**À créer** : écran de bienvenue prestataire (`3998b169`).

### 8. Provider - Ops & Reviews (7 écrans)
`4904714d`, `8a2d2715`, `431de011`, `5cc297f2`, `201cd770`, `33c63c0c`, `532f66e7`, `095d6c40`

**À créer** : modale/écran de confirmation d'acceptation (`431de011`).

---

## Recommandations de priorisation

### P0 — Fondations (à faire en premier)
- Cleanup des tokens thème sur les 66 écrans existants.
- Création du UI kit partagé.
- Création des notifiers métier manquants.

### P1 — Flux critiques utilisateur
1. Onboarding & Auth (11 écrans) — porte d'entrée de l'app.
2. Client Home & Discovery (5 écrans) — cœur de l'expérience client.
3. Client Demandes & Missions (10 écrans) — valeur métier principale.

### P2 — Messagerie & Avis
- Messages (3 écrans)
- Reviews client + prestataire (4 écrans)

### P3 — Settings, Support & Legal
- 22 écrans, beaucoup utilisent des layouts similaires ; peut être traité en lot avec le UI kit.

### P4 — Parcours Prestataire
- Provider onboarding, setup, ops, reviews (16 écrans).

### P5 — Admin
- Login admin (`e47df3d0`) et, si applicable, module admin complet (hors scope des 71 écrans visibles).

---

## Écarts à résoudre avant intégration

1. **Étape photos manquante** dans la création de demande (`d4095137`).
2. **Écran détail FAQ manquant** (`0147bf56`).
3. **Écran bienvenue prestataire manquant** (`3998b169`).
4. **Confirmation d'acceptation prestataire** (`431de011`) — actuellement gérée inline dans `provider_request_detail_screen.dart`, à extraire en composant/modal dédié.
5. **Login admin** (`e47df3d0`) — décider s'il faut un écran dédié ou une variante du login existant.
6. **Thème inconsistant** sur plusieurs écrans existants (couleurs hardcodées).
7. **Notifiers métier manquants** : Discovery, Request, Mission, Message, Review, ProviderProfile.
