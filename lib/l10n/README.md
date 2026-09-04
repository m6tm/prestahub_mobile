# 🌍 Gestion de l'Internationalisation (i18n)

Ce projet utilise **slang** pour la gestion des traductions. Les fichiers sont découpés par **namespaces** (domaines fonctionnels) afin de maintenir une base de code propre et évolutive.

## 📂 Structure des fichiers

Les traductions se trouvent dans `lib/l10n/`. Chaque langue possède son propre dossier, et chaque dossier contient plusieurs fichiers par domaine fonctionnel :

```text
lib/l10n/
├── fr/                      # Locale de base (Français)
│   ├── auth.i18n.yaml       # Connexion, inscription, mot de passe
│   ├── common.i18n.yaml     # Termes génériques (boutons, états communs)
│   ├── discovery.i18n.yaml  # Recherche, catégories, fiche prestataire
│   ├── errors.i18n.yaml     # Messages d'erreur et validation
│   ├── home.i18n.yaml       # Accueil et navigation
│   ├── messages.i18n.yaml   # Messagerie
│   ├── onboarding.i18n.yaml # Tutoriel de première ouverture
│   ├── requests.i18n.yaml   # Demandes, missions, avis
│   └── settings.i18n.yaml   # Paramètres, profil, support, sécurité
├── en/                      # Anglais
│   ├── auth.i18n.yaml
│   ├── common.i18n.yaml
│   ├── discovery.i18n.yaml
│   ├── errors.i18n.yaml
│   ├── home.i18n.yaml
│   ├── messages.i18n.yaml
│   ├── onboarding.i18n.yaml
│   ├── requests.i18n.yaml
│   └── settings.i18n.yaml
└── README.md                # Ce fichier
```

> **Règle d'or :** aucune langue ne doit tenir dans un seul fichier. Les traductions sont obligatoirement découpées par domaine fonctionnel (namespace).

## 📜 Règles de création et modification

### 1. Format des fichiers
- Utilisez exclusivement le format **YAML** (`.i18n.yaml`).
- Le nom du fichier définit le **namespace**. Par exemple, `auth.i18n.yaml` créera un accès via `t.auth`.

### 2. Organisation hiérarchique
- Regroupez les clés par écran ou composant à l'intérieur de chaque fichier.
- Utilisez le `camelCase` pour les clés (configuré dans `slang.yaml`).

### 3. Ajout d'une nouvelle clé
1. Ajoutez la clé dans le fichier correspondant de la langue par défaut (`fr/`).
2. Ajoutez la traduction dans les autres langues (`en/`).
3. Si un nouveau domaine est nécessaire, créez un nouveau fichier `domaine.i18n.yaml` dans **chaque** langue.

### 4. Génération du code
Après chaque modification des fichiers de traduction, lancez la génération :

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🛠️ Utilisation dans le code

Pour accéder à une traduction :

```dart
import 'package:prestahub/l10n/translations.g.dart';

// Dans un widget
Text(t.auth.login.title)
Text(t.common.buttons.save)
Text(t.settings.title)

// Avec paramètres
// home.i18n.yaml: hello_user: "Bonjour, ${name}"
Text(t.home.helloUser(name: 'Jean'))
```
