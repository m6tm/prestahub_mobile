# Epic 01 — Identité UI (thème violet) & UI kit (TailwindCSS)

## Objectif
Mettre en place le design system (tokens) et une base de composants UI réutilisables avec TailwindCSS, en respectant la responsivité et l’accessibilité.

## Tickets

### TCK-0101 — Définir les tokens CSS du thème violet [DONE]
- **Priorité** : Haute
- **User story** : En tant que PO, je veux un thème violet cohérent pour que l’application ait une identité visuelle forte.
- **Critères d’acceptation** :
  - Tokens sémantiques disponibles (bg/surface/text/primary/states/border/focus).
  - Valeurs définies pour light (et dark si activé).
- **Tâches techniques** :
  - Implémenter les variables CSS correspondant à `docs/selection-theme.md`.
  - Prévoir organisation pour extension (nouvelles couleurs/états).
- **Dépendances** : Epic 00 (Tailwind + socle).

### TCK-0102 — Intégrer les tokens dans TailwindCSS [DONE]
- **Priorité** : Haute
- **User story** : En tant que dev, je veux consommer les tokens via des utilitaires Tailwind pour accélérer le dev UI.
- **Critères d’acceptation** :
  - Les classes utilitaires utilisent les tokens (ex : `bg-[var(--color-bg)]` ou config thème Tailwind).
  - Pas de couleurs “hardcodées” dans les composants.
- **Tâches techniques** :
  - Choisir stratégie d’intégration (CSS vars + config Tailwind).
  - Documenter conventions d’usage.
- **Dépendances** : TCK-0101.

### TCK-0103 — Mettre en place la typographie et l’échelle responsive [DONE]
- **Priorité** : Moyenne
- **User story** : En tant qu’utilisateur, je veux une UI lisible sur mobile et desktop.
- **Critères d’acceptation** :
  - Tailles de texte et line-height cohérents.
  - Breakpoints définis.
- **Tâches techniques** :
  - Définir variables typo et styles de base.
  - Configurer breakpoints et containers.
- **Dépendances** : Epic 00.

### TCK-0104 — Composants UI de base (UI kit) [DONE]
- **Priorité** : Haute
- **User story** : En tant que dev, je veux des composants standards pour réduire les incohérences.
- **Critères d’acceptation** :
  - Composants : Button, Input, Select, Textarea, Card, Badge, Alert, Modal/Drawer.
  - États : hover/active/disabled/loading.
- **Tâches techniques** :
  - Créer composants Svelte réutilisables.
  - Garantir accessibilité (focus, aria si nécessaire).
- **Dépendances** : TCK-0102.

### TCK-0105 — Navigation layout responsive [DONE]
- **Priorité** : Haute
- **User story** : En tant qu’utilisateur, je veux naviguer facilement sur mobile.
- **Critères d’acceptation** :
  - Layout responsive (header + menu).
  - Pages principales accessibles.
- **Tâches techniques** :
  - Implémenter layout SvelteKit.
  - Menu mobile (drawer) et desktop.
- **Dépendances** : TCK-0104.
