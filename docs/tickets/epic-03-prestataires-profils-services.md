# Epic 03 — Prestataires : profils, services, zones

## Objectif
Permettre aux prestataires de créer un profil complet (services, description, tarifs indicatifs, zone) et aux clients de consulter ces profils.

## Tickets

### TCK-0301 — Création et édition du profil prestataire
- **Priorité** : Haute
- **User story** : En tant que prestataire, je veux compléter mon profil afin d’être trouvé.
- **Critères d’acceptation** :
  - Formulaire profil prestataire (nom commercial, bio, téléphone, photo).
  - Sauvegarde et affichage.
- **Tâches techniques** :
  - Entité/agrégat profil prestataire (domain).
  - Repository Supabase + RLS.
- **Dépendances** : Epic 02.

### TCK-0302 — Gestion des catégories/services
- **Priorité** : Haute
- **User story** : En tant que prestataire, je veux sélectionner les services proposés.
- **Critères d’acceptation** :
  - Sélection multi-services.
  - Services visibles côté fiche prestataire.
- **Tâches techniques** :
  - Tables catégories/services.
  - Relations prestataire ↔ services.
- **Dépendances** : TCK-0301.

### TCK-0303 — Zone de service et localisation
- **Priorité** : Haute
- **User story** : En tant que prestataire, je veux définir ma zone d’intervention.
- **Critères d’acceptation** :
  - Ville/quartier obligatoire.
  - Coordonnées optionnelles.
- **Tâches techniques** :
  - Modèle `Localisation`.
  - Validation + stockage.
- **Dépendances** : TCK-0301.

### TCK-0304 — Tarifs indicatifs
- **Priorité** : Moyenne
- **User story** : En tant que client, je veux avoir une idée du prix.
- **Critères d’acceptation** :
  - Fourchette ou type (horaire/forfait).
- **Tâches techniques** :
  - Champs tarifs + affichage.
- **Dépendances** : TCK-0301.

### TCK-0305 — Upload avatar/galerie (Supabase Storage)
- **Priorité** : Moyenne
- **User story** : En tant que prestataire, je veux ajouter une photo.
- **Critères d’acceptation** :
  - Upload OK, récupération URL, suppression/remplacement.
- **Tâches techniques** :
  - Adapter `StoragePort`.
  - Politiques de bucket (public/privé).
- **Dépendances** : Epic 00 (Supabase Storage).

### TCK-0306 — Page fiche prestataire (publique)
- **Priorité** : Haute
- **User story** : En tant que client, je veux consulter une fiche complète.
- **Critères d’acceptation** :
  - Profil, services, zone, tarifs, avis (si dispo).
- **Tâches techniques** :
  - Route SvelteKit + fetch sécurisé.
- **Dépendances** : TCK-0301, TCK-0302.
