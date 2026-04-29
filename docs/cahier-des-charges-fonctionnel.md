# Cahier des charges fonctionnel — Prestahub

## 1. Contexte et problématique
Dans de nombreux pays d’Afrique, la mise en relation entre particuliers/entreprises et prestataires de services (artisans, techniciens, freelances, etc.) est difficile.
Les principaux freins observés sont :
- La difficulté à identifier un prestataire fiable et disponible.
- L’absence de visibilité sur les tarifs, la qualité et les avis.
- La complexité de la coordination (prise de rendez-vous, suivi, annulation, replanification).
- Le manque de garanties (paiement, litiges, respect des engagements).

## 2. Objectifs du produit
### 2.1 Objectifs principaux
- Permettre aux clients de **trouver rapidement** des prestataires proches, compétents et disponibles.
- Permettre aux prestataires de **développer leur activité** (leads qualifiés, visibilité, gestion de planning).
- Instaurer de la **confiance** via profil vérifié, évaluations, historique de missions, modération.

### 2.2 Indicateurs de succès (KPI)
- Taux de conversion recherche → demande de service.
- Taux d’acceptation des demandes par les prestataires.
- Délai moyen entre demande et prise en charge.
- Taux de missions terminées / annulées.
- Note moyenne prestataires, nombre d’avis par mission.
- Rétention 30/90 jours côté client et prestataire.
- Part de paiements réalisés via la plateforme (si applicable).

## 3. Périmètre
### 3.1 Périmètre MVP (version 1)
- Inscription / connexion.
- Profils client et prestataire.
- Catalogue de catégories de services.
- Recherche de prestataires (localisation + filtres) et consultation de profils.
- Demande de service (brief + disponibilité + localisation).
- Acceptation/refus + messagerie.
- Statuts de mission (en cours, terminée, annulée).
- Évaluation et avis.
- Back-office d’administration (modération, catégories, utilisateurs).

### 3.2 Hors périmètre MVP (évolutions ultérieures)
- Paiement en ligne, escrow, facture automatique.
- Devis structurés, estimation automatique.
- Appels VoIP intégrés.
- Abonnements premium prestataires.
- Programme de fidélité.
- API publique partenaires.

## 4. Parties prenantes
- **Client** : particulier ou entreprise qui cherche un service.
- **Prestataire** : professionnel proposant des prestations.
- **Administrateur** : gestion de la plateforme, modération, support.
- **Support/Modération** : gestion des signalements, litiges, contenus.

## 5. Personas (exemples)
### 5.1 Client (particulier)
- Besoin : trouver un plombier rapidement, à proximité, avec des avis.
- Attentes : simplicité, transparence (prix/avis), réactivité.

### 5.2 Prestataire (indépendant)
- Besoin : recevoir des demandes qualifiées et gérer son planning.
- Attentes : visibilité, confiance, protection contre les demandes abusives.

## 6. Parcours utilisateurs (User Journeys)
### 6.1 Parcours client (recherche → mission terminée)
1. Le client s’inscrit/se connecte.
2. Il choisit une catégorie (ex : électricien) et une zone.
3. Il consulte une liste de prestataires (tri par distance/avis).
4. Il ouvre un profil, vérifie avis, prix indicatif, disponibilité.
5. Il crée une demande (description, photos éventuelles, date/heure, adresse).
6. Le prestataire accepte et une conversation démarre.
7. La mission passe par les statuts : planifiée → en cours → terminée.
8. Le client note et laisse un avis.

### 6.2 Parcours prestataire (inscription → acquisition)
1. Le prestataire s’inscrit.
2. Il complète son profil (services, zone, prix indicatif, expérience).
3. Il soumet des justificatifs (optionnel MVP selon choix de vérification).
4. Il reçoit une demande et l’accepte/refuse.
5. Il échange avec le client, réalise la mission.
6. Il obtient une évaluation.

## 7. Rôles et permissions
- **Client**
  - Créer/éditer son profil.
  - Rechercher et consulter les prestataires.
  - Créer une demande, annuler selon règles.
  - Messagerie.
  - Noter/avis.
- **Prestataire**
  - Créer/éditer profil, gérer services, zone, disponibilité.
  - Recevoir demandes, accepter/refuser.
  - Messagerie.
  - Mettre à jour statuts de mission (selon règles).
- **Administrateur**
  - Gérer utilisateurs (suspension, vérification).
  - Gérer catégories/services.
  - Modérer avis et contenus.
  - Consulter tableaux de bord.

## 8. Fonctionnalités détaillées (MVP)

### 8.1 Authentification et comptes
- Création de compte par :
  - Téléphone + OTP (recommandé en Afrique).
  - Email + mot de passe (optionnel).
- Réinitialisation et gestion de session.
- Acceptation des conditions d’utilisation.

### 8.2 Profil client
- Informations minimales : nom/prénom, téléphone, ville/quartier.
- Gestion des adresses (une ou plusieurs).
- Historique des demandes/missions.

### 8.3 Profil prestataire
- Informations : nom commercial, téléphone, description, photo, zone de service.
- Catégories et services proposés.
- Prix indicatifs (fourchette) ou mode de tarification (horaire/forfait).
- Disponibilités (simple : jours/horaires, ou calendrier ultérieur).
- Pièces justificatives (optionnel en MVP) : pièce d’identité, registre, certification.
- Statut de vérification : non vérifié / en attente / vérifié / refusé.

### 8.4 Catalogue des services
- Liste de catégories (ex : plomberie, électricité, menuiserie, peinture, ménage, climatisation, informatique, etc.).
- Possibilité d’activer/désactiver une catégorie côté admin.

### 8.5 Recherche et découverte
- Recherche par :
  - Catégorie.
  - Localisation (ville/quartier, ou géolocalisation si acceptée).
  - Disponibilité (simple).
  - Note minimale.
- Résultats avec : distance approximative, note, nombre d’avis, badge vérifié.
- Fiche prestataire : détails, services, galerie (optionnel), avis, zone couverte.

### 8.6 Demande de service (lead)
- Formulaire de demande :
  - Catégorie.
  - Description du besoin.
  - Adresse / point de repère.
  - Urgence (immédiat, aujourd’hui, date planifiée).
  - Créneaux souhaités.
  - Photos (optionnel).
- Choix d’envoi :
  - À un prestataire spécifique.
  - Ou diffusion à plusieurs prestataires de la zone (option avancée).

### 8.7 Gestion des demandes et missions
- États recommandés :
  - Brouillon (optionnel).
  - Envoyée.
  - Acceptée.
  - Refusée.
  - Planifiée.
  - En cours.
  - Terminée.
  - Annulée.
- Règles de base :
  - Le prestataire peut accepter/refuser.
  - Le client peut annuler avant acceptation, et après acceptation selon conditions.
  - Historique complet des changements de statut.

### 8.8 Messagerie
- Conversation client-prestataire liée à une demande.
- Pièces jointes (images) optionnelles.
- Notifications : push (mobile) ou SMS (option), et email (option).

### 8.9 Avis et notation
- Avis autorisé uniquement après mission terminée.
- Note 1 à 5 + commentaire.
- Système de signalement d’un avis.
- Modération admin : masquer/supprimer selon règles.

### 8.10 Administration (Back-office)
- Dashboard : volumes (demandes, missions, utilisateurs).
- Gestion des catégories.
- Gestion des utilisateurs :
  - Recherche, suspension, suppression logique.
  - Validation des prestataires (si vérification activée).
- Modération des avis.
- Gestion des signalements.

## 9. Règles métiers (principes)
- Un prestataire ne peut être contacté que s’il a un profil actif.
- Les avis sont liés à une mission terminée.
- Un utilisateur suspendu ne peut plus initier d’actions (demande, acceptation, message).
- Les modifications de statut sont tracées.

## 10. Exigences non-fonctionnelles
### 10.1 Performance et disponibilité
- Temps de réponse cible :
  - Recherche : < 2s en conditions nominales.
  - Consultation profil : < 1s.
- Tolérance aux connexions instables (mobile data).

### 10.2 Sécurité
- Stockage sécurisé des mots de passe (si email/password) via hachage.
- Protection OTP contre abus (limites par numéro/IP).
- Rôles et permissions stricts.
- Journalisation des actions sensibles (admin, suspension, suppression).

### 10.3 Confidentialité et conformité
- Politique de confidentialité claire.
- Minimisation des données.
- Gestion du consentement géolocalisation.
- Droit de suppression de compte (suppression logique + anonymisation selon politique).

### 10.4 Qualité et maintenance
- Architecture permettant l’évolution (ajout paiement, devis, abonnement).
- Logs exploitables et alertes.

## 11. Contraintes et hypothèses
- Ciblage initial : 1 ou 2 villes/pays pour tester le PMF.
- Forte utilisation mobile : priorité UX mobile.
- OTP via fournisseur SMS : coût à anticiper.

## 12. Écrans attendus (liste)
### 12.1 Client
- Accueil / choix de catégorie.
- Résultats de recherche.
- Fiche prestataire.
- Création de demande.
- Détail demande + conversation.
- Historique.
- Profil / paramètres.

### 12.2 Prestataire
- Inscription + création profil.
- Tableau de bord demandes.
- Détail demande + conversation.
- Gestion profil, services, zone, disponibilités.
- Historique missions.

### 12.3 Admin
- Connexion.
- Dashboard.
- Catégories.
- Utilisateurs.
- Vérifications.
- Avis / signalements.

## 13. Critères d’acceptation (exemples)
- Un client peut créer une demande et la voir dans son historique.
- Un prestataire reçoit la demande et peut l’accepter/refuser.
- Une conversation est créée automatiquement après acceptation.
- Une mission terminée permet au client de laisser un avis.
- Un admin peut suspendre un utilisateur et l’empêcher d’agir.

## 14. Roadmap suggérée
- **Phase 1 (MVP)** : mise en relation + demandes + avis + admin.
- **Phase 2** : vérification avancée + géolocalisation précise + diffusion multi-prestataires.
- **Phase 3** : paiement + litiges + commissions + abonnements.

## 15. Points à valider (questions)
- Le MVP inclut-il un paiement in-app ou uniquement une mise en relation ?
- Souhaites-tu une diffusion d’une demande à plusieurs prestataires (type marketplace) ?
- Vérification prestataire obligatoire dès le départ ou progressive ?
- Ciblage initial : quel pays/ville et quelles catégories prioritaires ?
