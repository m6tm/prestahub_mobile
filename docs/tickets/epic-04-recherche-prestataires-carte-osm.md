# Epic 04 — Recherche prestataires & carte OpenStreetMap

## Objectif
Permettre au client de rechercher des prestataires par catégorie et zone, avec affichage liste + carte (OpenStreetMap).

## Tickets

### TCK-0401 — Page recherche : filtres + résultats
- **Priorité** : Haute
- **User story** : En tant que client, je veux filtrer par catégorie et localisation.
- **Critères d’acceptation** :
  - Filtres : catégorie, ville/quartier, note minimale (option).
  - Liste paginée/limitée.
- **Tâches techniques** :
  - Endpoint `GET /providers` avec paramètres.
  - Index DB nécessaires.
- **Dépendances** : Epic 03.

### TCK-0402 — Tri et affichage résumé prestataire
- **Priorité** : Moyenne
- **User story** : En tant que client, je veux voir distance approximative/avis.
- **Critères d’acceptation** :
  - Cards prestataires : nom, note, badges.
- **Tâches techniques** :
  - Calcul distance si coords dispo (MVP : approximatif ou absent).
- **Dépendances** : TCK-0401.

### TCK-0403 — Intégration carte OpenStreetMap (Leaflet)
- **Priorité** : Moyenne
- **User story** : En tant que client, je veux visualiser les prestataires sur une carte.
- **Critères d’acceptation** :
  - Carte chargée.
  - Marqueurs prestataires.
- **Tâches techniques** :
  - Intégrer Leaflet.
  - Gérer SSR (import dynamique si nécessaire).
- **Dépendances** : TCK-0401.

### TCK-0404 — Sélection d’un prestataire depuis la carte
- **Priorité** : Basse
- **User story** : En tant que client, je veux cliquer un marqueur pour ouvrir la fiche.
- **Critères d’acceptation** :
  - Click marker → ouverture fiche.
- **Tâches techniques** :
  - Interaction carte → routing.
- **Dépendances** : TCK-0403, Epic 03.

### TCK-0405 — Géolocalisation navigateur (option)
- **Priorité** : Basse
- **User story** : En tant que client, je veux utiliser ma position.
- **Critères d’acceptation** :
  - Consentement demandé.
  - Fallback si refus.
- **Tâches techniques** :
  - API Geolocation.
- **Dépendances** : TCK-0401.
