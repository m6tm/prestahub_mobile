# 🌍 Gestion de l'Internationalisation (i18n)

Ce projet utilise **slang** pour la gestion des traductions. Les fichiers sont découpés par **namespaces** (domaines fonctionnels) afin de maintenir une base de code propre et évolutive.

## 📂 Structure des fichiers

Les traductions se trouvent dans `lib/l10n/`. La structure est organisée par langue :

```text
lib/l10n/
├── fr/                  # Locale de base (Français)
│   ├── common.i18n.yaml # Termes génériques (boutons, erreurs communes)
│   ├── auth.i18n.yaml   # Connexion, inscription, profil
│   └── ...
├── en/                  # Anglais
│   ├── common.i18n.yaml
│   ├── auth.i18n.yaml
│   └── ...
└── README.md            # Ce fichier
```

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
3. Si un nouveau domaine est nécessaire, créez un nouveau fichier `domaine.i18n.yaml` dans chaque langue.

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

// Avec paramètres
// auth.i18n.yaml: welcome: "Bienvenue $name !"
Text(t.auth.welcome(name: 'Jean'))
```
