# Epic 00 — Fondations & architecture

## Objectif
Mettre en place la base du projet SvelteKit (front+back) avec architecture hexagonale, conventions de code, configuration TailwindCSS et socle technique pour permettre le développement sécurisé et scalable.

## Tickets

### TCK-0001 — Initialiser le projet SvelteKit [DONE]
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux une base SvelteKit prête au dev afin de démarrer rapidement.
- **Critères d’acceptation** :
  - Projet démarre en local.
  - Pages et endpoints fonctionnent.
  - Configuration environnement dev prête.
- **Tâches techniques** :
  - Créer projet SvelteKit.
  - Définir structure `src/` selon architecture hexagonale.
  - Configurer TypeScript et lint/format si retenus.
- **Dépendances** : Aucune.

### TCK-0002 — Mettre en place l’architecture hexagonale (squelettes) [DONE]
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux des dossiers et conventions hexagonales pour isoler domaine et infra.
- **Critères d’acceptation** :
  - Existence des modules `domain`, `application`, `ports`, `infrastructure`, `presentation`.
  - Exemple minimal de use case + port + adapter.
- **Tâches techniques** :
  - Définir interfaces de ports (placeholders).
  - Définir conventions de nommage (ports/adapters/usecases).
- **Dépendances** : TCK-0001.

### TCK-0003 — Configuration des variables d’environnement [DONE]
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux une gestion propre des variables d’environnement pour éviter les secrets dans le code.
- **Critères d’acceptation** :
  - Validation des variables au démarrage.
  - Distinction variables publiques/privées.
- **Tâches techniques** :
  - Définir schéma de validation.
  - Documenter variables nécessaires (Supabase, Firebase, email, app URL).
- **Dépendances** : TCK-0001.

### TCK-0004 — Intégrer Supabase (client + server) [DONE]
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux une intégration Supabase utilisable côté client et côté serveur.
- **Critères d’acceptation** :
  - Client Supabase initialisé via env.
  - Accès serveur distinct (si service role nécessaire) uniquement côté serveur.
- **Tâches techniques** :
  - Créer adaptateurs infrastructure pour Supabase.
  - Mettre en place helpers de session.
- **Dépendances** : TCK-0003.

### TCK-0005 — Mettre en place TailwindCSS [DONE]
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux TailwindCSS opérationnel pour construire l’UI rapidement.
- **Critères d’acceptation** :
  - Styles Tailwind appliqués.
  - Build prod OK.
- **Tâches techniques** :
  - Installer/configurer Tailwind.
  - Définir conventions (classes utilitaires, composants).
- **Dépendances** : TCK-0001.

### TCK-0006 — Mettre en place le système de thème (tokens CSS) [DONE]
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux des tokens CSS (violet) pour garantir une UI cohérente.
- **Critères d’acceptation** :
  - Tokens CSS définis pour couleurs/typo/spacing.
  - Utilisation dans l’UI démontrée sur une page.
- **Tâches techniques** :
  - Créer fichier CSS tokens (light/dark si retenu).
  - Mapper tokens avec Tailwind (si extension config).
- **Dépendances** : TCK-0005.

### TCK-0007 — Logger serveur et gestion d’erreurs
- **Priorité** : Moyenne
- **User story** : En tant qu’équipe, je veux des logs et des erreurs exploitables pour diagnostiquer.
- **Critères d’acceptation** :
  - Logs structurés sur endpoints.
  - Gestion des erreurs cohérente.
- **Tâches techniques** :
  - Définir wrapper de réponse d’erreur.
  - Ajouter logs sur actions clés.
- **Dépendances** : TCK-0001.

### TCK-0008 — Déploiement Vercel (staging) [DONE]
- **Priorité** : Haute
- **User story** : En tant qu’équipe, je veux un déploiement staging sur Vercel pour valider en continu.
- **Critères d’acceptation** :
  - Déploiement automatique sur branche staging.
  - Variables d’environnement configurées.
- **Tâches techniques** :
  - Configurer projet Vercel.
  - Ajouter env staging.
- **Dépendances** : TCK-0003.
