# Thème UI (Design System) — Prestahub
> Design premium : Glassmorphism · Animations fluides · Illustrations modernes

---

## 1. Objectif

Définir le **thème visuel** de l'application avec une esthétique **premium et moderne** :
- Identité violette forte avec dégradés profonds
- Effets **Glassmorphism** (surfaces translucides, flou, reflets)
- **Animations fluides** (micro-interactions, transitions, feedback)
- **Illustrations premium** (style cohérent, thématique métier)
- Typographies expressives et espacements généreux
- Accessibilité WCAG AA préservée malgré les effets visuels

---

## 2. Principes de design

- **Tokenisation stricte** : aucune valeur en dur dans les composants.
- **Glass-first** : les surfaces principales sont translucides sur fond dégradé.
- **Motion purposeful** : chaque animation a un sens (feedback, transition, emphase).
- **Cohérence** : un système de tokens partagé Flutter + Web.
- **Accessibilité** : contraste minimum 4.5:1, animations respectueuses de `prefers-reduced-motion`.

---

## 3. Fond & Atmosphère générale

L'UI repose sur un **fond dégradé profond** permanent, sur lequel flottent des surfaces en verre.

### 3.1 Fond principal (light)
```
background: linear-gradient(135deg, #EDE9FE 0%, #F5F3FF 40%, #FFFFFF 100%);
```

### 3.2 Fond principal (dark)
```
background: linear-gradient(135deg, #0B0B0F 0%, #1A0A2E 50%, #0D1117 100%);
```

### 3.3 Orbes / halos décoratifs (ambiance)
Des cercles lumineux flous positionnés en fond pour donner de la profondeur :
- **Orbe 1** (primaire) : `radial-gradient(circle, rgba(109,40,217,0.25) 0%, transparent 70%)` — top-left
- **Orbe 2** (accent) : `radial-gradient(circle, rgba(167,139,250,0.15) 0%, transparent 70%)` — bottom-right
- **Orbe 3** (neutre) : `radial-gradient(circle, rgba(196,181,253,0.10) 0%, transparent 70%)` — center

> En Flutter : ces orbes sont des `Container` avec `BoxDecoration` + `BoxShadow` / `BackdropFilter` placés en `Stack`.

---

## 4. Couleurs

### 4.1 Palette primitive — Violet (brand)

| Nom | Hex | Usage |
|---|---|---|
| `purple-50` | `#F5F3FF` | Fonds très légers |
| `purple-100` | `#EDE9FE` | Surfaces glass light |
| `purple-200` | `#DDD6FE` | Bordures glass light |
| `purple-300` | `#C4B5FD` | Textes secondaires dark |
| `purple-400` | `#A78BFA` | Accents, icônes |
| `purple-500` | `#8B5CF6` | Focus, highlights |
| `purple-600` | `#7C3AED` | Interactions hover |
| `purple-700` | `#6D28D9` | Primaire brand |
| `purple-800` | `#5B21B6` | Primaire pressed |
| `purple-900` | `#4C1D95` | Texte foncé on light |

### 4.2 Palette primitive — Neutres

| Nom | Hex |
|---|---|
| `white` | `#FFFFFF` |
| `black` | `#0B0B0F` |
| `gray-50` | `#F9FAFB` |
| `gray-100` | `#F3F4F6` |
| `gray-200` | `#E5E7EB` |
| `gray-300` | `#D1D5DB` |
| `gray-400` | `#9CA3AF` |
| `gray-500` | `#6B7280` |
| `gray-600` | `#4B5563` |
| `gray-700` | `#374151` |
| `gray-800` | `#1F2937` |
| `gray-900` | `#111827` |

### 4.3 Palette primitive — États

| Nom | Hex |
|---|---|
| `success-400` | `#4ADE80` |
| `success-600` | `#16A34A` |
| `warning-400` | `#FBBF24` |
| `warning-600` | `#D97706` |
| `danger-400` | `#F87171` |
| `danger-600` | `#DC2626` |
| `info-400` | `#60A5FA` |
| `info-600` | `#2563EB` |

### 4.4 Dégradés (gradients)

| Nom | Valeur |
|---|---|
| `gradient-brand` | `linear-gradient(135deg, #7C3AED 0%, #A78BFA 100%)` |
| `gradient-brand-deep` | `linear-gradient(135deg, #4C1D95 0%, #6D28D9 60%, #8B5CF6 100%)` |
| `gradient-aurora` | `linear-gradient(135deg, #6D28D9 0%, #8B5CF6 50%, #60A5FA 100%)` |
| `gradient-glow` | `radial-gradient(circle, #8B5CF6 0%, #6D28D9 60%, transparent 100%)` |
| `gradient-surface-light` | `linear-gradient(135deg, rgba(255,255,255,0.7) 0%, rgba(237,233,254,0.5) 100%)` |
| `gradient-surface-dark` | `linear-gradient(135deg, rgba(255,255,255,0.08) 0%, rgba(109,40,217,0.08) 100%)` |

### 4.5 Tokens sémantiques — Light

| Token | Valeur |
|---|---|
| `--color-bg` | `#FFFFFF` |
| `--color-bg-gradient` | `linear-gradient(135deg, #EDE9FE, #F5F3FF, #FFFFFF)` |
| `--color-surface` | `rgba(255,255,255,0.70)` |
| `--color-surface-2` | `rgba(245,243,255,0.60)` |
| `--color-surface-3` | `rgba(237,233,254,0.50)` |
| `--color-text` | `#111827` |
| `--color-text-muted` | `#4B5563` |
| `--color-text-subtle` | `#9CA3AF` |
| `--color-text-inverse` | `#FFFFFF` |
| `--color-border` | `rgba(196,181,253,0.40)` |
| `--color-border-strong` | `rgba(139,92,246,0.30)` |
| `--color-primary` | `#6D28D9` |
| `--color-primary-hover` | `#5B21B6` |
| `--color-primary-contrast` | `#FFFFFF` |
| `--color-primary-gradient` | `linear-gradient(135deg, #7C3AED, #A78BFA)` |
| `--color-focus` | `#8B5CF6` |
| `--color-focus-ring` | `rgba(139,92,246,0.40)` |
| `--color-success` | `#16A34A` |
| `--color-warning` | `#D97706` |
| `--color-danger` | `#DC2626` |
| `--color-info` | `#2563EB` |
| `--color-overlay` | `rgba(109,40,217,0.08)` |

### 4.6 Tokens sémantiques — Dark

| Token | Valeur |
|---|---|
| `--color-bg` | `#0B0B0F` |
| `--color-bg-gradient` | `linear-gradient(135deg, #0B0B0F, #1A0A2E, #0D1117)` |
| `--color-surface` | `rgba(255,255,255,0.06)` |
| `--color-surface-2` | `rgba(167,139,250,0.08)` |
| `--color-surface-3` | `rgba(109,40,217,0.10)` |
| `--color-text` | `#F9FAFB` |
| `--color-text-muted` | `#C4B5FD` |
| `--color-text-subtle` | `#7C3AED` |
| `--color-text-inverse` | `#0B0B0F` |
| `--color-border` | `rgba(167,139,250,0.15)` |
| `--color-border-strong` | `rgba(167,139,250,0.30)` |
| `--color-primary` | `#A78BFA` |
| `--color-primary-hover` | `#C4B5FD` |
| `--color-primary-contrast` | `#0B0B0F` |
| `--color-primary-gradient` | `linear-gradient(135deg, #6D28D9, #A78BFA)` |
| `--color-focus` | `#8B5CF6` |
| `--color-focus-ring` | `rgba(139,92,246,0.50)` |
| `--color-success` | `#4ADE80` |
| `--color-warning` | `#FBBF24` |
| `--color-danger` | `#F87171` |
| `--color-info` | `#60A5FA` |
| `--color-overlay` | `rgba(0,0,0,0.60)` |

---

## 5. Glassmorphism

Le glassmorphism est le style visuel central de Prestahub. Les surfaces ressemblent à du **verre dépoli flottant** au-dessus du fond dégradé.

### 5.1 Recette Glassmorphism

Une surface glass se compose de :
1. **Fond semi-transparent** (`background: rgba(...)`)
2. **Flou d'arrière-plan** (`backdrop-filter: blur(...)`)
3. **Bordure lumineuse** (`border: 1px solid rgba(...)`)
4. **Ombre douce** (`box-shadow`)
5. **Reflet interne** (pseudo-élément ou `inset shadow`)

### 5.2 Niveaux de glass

| Niveau | Usage | Background | Blur | Bordure |
|---|---|---|---|---|
| `glass-subtle` | Cartes secondaires | `rgba(255,255,255,0.40)` | `blur(8px)` | `rgba(255,255,255,0.50)` |
| `glass-default` | Cartes principales | `rgba(255,255,255,0.60)` | `blur(16px)` | `rgba(196,181,253,0.40)` |
| `glass-strong` | Modales, sheets | `rgba(255,255,255,0.75)` | `blur(24px)` | `rgba(139,92,246,0.30)` |
| `glass-frosted` | Nav bar, headers | `rgba(255,255,255,0.85)` | `blur(32px)` | `rgba(139,92,246,0.20)` |

> **Dark mode** : remplacer `rgba(255,255,255,X)` par `rgba(255,255,255,0.05~0.12)`.

### 5.3 Tokens Glassmorphism

```css
/* Glass Default */
--glass-bg: rgba(255, 255, 255, 0.60);
--glass-bg-dark: rgba(255, 255, 255, 0.07);
--glass-blur: blur(16px);
--glass-border: 1px solid rgba(196, 181, 253, 0.40);
--glass-border-dark: 1px solid rgba(167, 139, 250, 0.15);
--glass-shadow: 0 8px 32px rgba(109, 40, 217, 0.12), 0 2px 8px rgba(0,0,0,0.06);
--glass-shadow-dark: 0 8px 32px rgba(0, 0, 0, 0.40), 0 2px 8px rgba(109,40,217,0.20);
--glass-reflet: inset 0 1px 0 rgba(255,255,255,0.60); /* reflet haut */

/* Glass Strong (modale) */
--glass-strong-bg: rgba(255, 255, 255, 0.75);
--glass-strong-bg-dark: rgba(255, 255, 255, 0.10);
--glass-strong-blur: blur(24px);
--glass-strong-shadow: 0 20px 60px rgba(109, 40, 217, 0.20), 0 4px 16px rgba(0,0,0,0.10);
```

### 5.4 Implémentation Flutter

```dart
// Composant GlassCard Flutter
Container(
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.60),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Color(0xFFC4B5FD).withOpacity(0.40),
      width: 1.0,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF6D28D9).withOpacity(0.12),
        blurRadius: 32,
        offset: Offset(0, 8),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: child,
    ),
  ),
)
```

### 5.5 Règles d'utilisation glass

- Toujours placer les surfaces glass sur un fond coloré (dégradé ou image).
- Le texte sur glass doit respecter le ratio de contraste WCAG AA.
- Ne pas superposer trop de niveaux (max 2 niveaux de glass empilés).
- Sur les inputs glass : fond `rgba(255,255,255,0.50)` + blur léger `8px`.

---

## 6. Typographies

### 6.1 Familles de polices

| Token | Police | Fallback | Usage |
|---|---|---|---|
| `--font-family-display` | `Plus Jakarta Sans` | `Inter, sans-serif` | Titres hero, grands titres |
| `--font-family-sans` | `Inter` | `system-ui, sans-serif` | Corps de texte, UI |
| `--font-family-mono` | `JetBrains Mono` | `monospace` | Codes, identifiants |

> Charger via Google Fonts : `Plus Jakarta Sans` (weights 600, 700, 800) + `Inter` (weights 400, 500, 600).

### 6.2 Échelle typographique

| Token | Taille | Line-height | Weight | Usage |
|---|---|---|---|---|
| `--font-size-display` | `40px / 2.5rem` | `1.15` | `800` | Hero, écran d'accueil |
| `--font-size-h1` | `32px / 2rem` | `1.20` | `700` | Titres de page |
| `--font-size-h2` | `24px / 1.5rem` | `1.25` | `700` | Titres de section |
| `--font-size-h3` | `20px / 1.25rem` | `1.30` | `600` | Titres de carte |
| `--font-size-h4` | `17px / 1.0625rem` | `1.35` | `600` | Sous-titres |
| `--font-size-body-lg` | `16px / 1rem` | `1.60` | `400` | Corps principal |
| `--font-size-body` | `14px / 0.875rem` | `1.60` | `400` | Corps standard |
| `--font-size-body-sm` | `13px / 0.8125rem` | `1.55` | `400` | Corps compact |
| `--font-size-caption` | `12px / 0.75rem` | `1.50` | `500` | Labels, badges |
| `--font-size-overline` | `11px / 0.6875rem` | `1.40` | `600` | Surlignages, catégories |

### 6.3 Effets typographiques premium

```css
/* Titre avec dégradé (hero) */
.text-gradient {
  background: linear-gradient(135deg, #6D28D9, #A78BFA, #60A5FA);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* Glow sur titre */
.text-glow {
  text-shadow: 0 0 40px rgba(139, 92, 246, 0.50);
}
```

> En Flutter : utiliser `ShaderMask` avec `LinearGradient` pour les textes dégradés.

---

## 7. Espacements

Échelle basée sur `4px` (base unit = `4px`).

| Token | Valeur | Usage |
|---|---|---|
| `--space-1` | `4px` | Micro (gap icône/texte) |
| `--space-2` | `8px` | Compact (padding badge) |
| `--space-3` | `12px` | Petit (gap interne) |
| `--space-4` | `16px` | Standard (padding card) |
| `--space-5` | `20px` | Medium |
| `--space-6` | `24px` | Large (section padding) |
| `--space-8` | `32px` | XL (espacement entre sections) |
| `--space-10` | `40px` | 2XL |
| `--space-12` | `48px` | 3XL (hero padding) |
| `--space-16` | `64px` | 4XL |
| `--space-20` | `80px` | Page padding top |

---

## 8. Radius (arrondis)

| Token | Valeur | Usage |
|---|---|---|
| `--radius-xs` | `4px` | Badges, chips, tags |
| `--radius-sm` | `8px` | Boutons secondaires, inputs |
| `--radius-md` | `12px` | Boutons principaux, selects |
| `--radius-lg` | `16px` | Cartes compactes |
| `--radius-xl` | `20px` | Cartes principales (glass) |
| `--radius-2xl` | `24px` | Bottom sheets, modales |
| `--radius-3xl` | `32px` | Hero cards, images |
| `--radius-full` | `9999px` | Pills, avatars, FAB |

---

## 9. Ombres & Effets de lumière

### 9.1 Ombres standard

| Token | Valeur | Usage |
|---|---|---|
| `--shadow-xs` | `0 1px 2px rgba(0,0,0,0.05)` | Micro elevation |
| `--shadow-sm` | `0 2px 8px rgba(0,0,0,0.08)` | Cartes légères |
| `--shadow-md` | `0 4px 16px rgba(0,0,0,0.10)` | Cartes standard |
| `--shadow-lg` | `0 8px 32px rgba(0,0,0,0.12)` | Dropdowns, popovers |
| `--shadow-xl` | `0 16px 48px rgba(0,0,0,0.15)` | Modales, bottom sheets |
| `--shadow-2xl` | `0 24px 64px rgba(0,0,0,0.20)` | Hero éléments |

### 9.2 Ombres colorées (brand glow)

| Token | Valeur | Usage |
|---|---|---|
| `--shadow-glow-sm` | `0 4px 16px rgba(109,40,217,0.25)` | Boutons primaires hover |
| `--shadow-glow-md` | `0 8px 32px rgba(109,40,217,0.30)` | CTA, éléments actifs |
| `--shadow-glow-lg` | `0 12px 48px rgba(109,40,217,0.40)` | Hero buttons, accents |
| `--shadow-glow-xl` | `0 20px 60px rgba(109,40,217,0.50)` | Éléments premium |

### 9.3 Reflets internes (inset)

```css
--shadow-inset-light: inset 0 1px 0 rgba(255,255,255,0.80); /* reflet haut */
--shadow-inset-glass: inset 0 1px 0 rgba(255,255,255,0.60), inset 0 -1px 0 rgba(0,0,0,0.04);
```

---

## 10. Animations & Motion

### 10.1 Principes

- **Purposeful** : chaque animation informe l'utilisateur (feedback, état, hiérarchie).
- **Rapide** : les micro-interactions < 200ms, les transitions de page ≤ 400ms.
- **Physique** : les courbes d'easing simulent des mouvements naturels.
- **Accessible** : toujours respecter `prefers-reduced-motion: reduce`.

### 10.2 Durées

| Token | Valeur | Usage |
|---|---|---|
| `--duration-instant` | `50ms` | Feedback toucher immédiat |
| `--duration-fast` | `100ms` | Hover states, couleurs |
| `--duration-normal` | `200ms` | Micro-interactions, boutons |
| `--duration-moderate` | `300ms` | Modales, dropdowns |
| `--duration-slow` | `400ms` | Transitions de page |
| `--duration-crawl` | `600ms` | Animations d'entrée héroïques |
| `--duration-lazy` | `1000ms` | Effets de fond, orbes |

### 10.3 Courbes d'easing

| Token | Valeur cubic-bezier | Caractère |
|---|---|---|
| `--ease-standard` | `cubic-bezier(0.4, 0.0, 0.2, 1)` | Entrée/sortie douce (Material) |
| `--ease-decelerate` | `cubic-bezier(0.0, 0.0, 0.2, 1)` | Entrée rapide, sortie lente (éléments qui arrivent) |
| `--ease-accelerate` | `cubic-bezier(0.4, 0.0, 1.0, 1)` | Entrée lente, sortie rapide (éléments qui partent) |
| `--ease-spring` | `cubic-bezier(0.34, 1.56, 0.64, 1)` | Effet rebond (spring) pour les popups/cartes |
| `--ease-bounce` | `cubic-bezier(0.68, -0.55, 0.265, 1.55)` | Rebond prononcé (icônes, badges) |
| `--ease-smooth` | `cubic-bezier(0.25, 0.46, 0.45, 0.94)` | Fluide général |

### 10.4 Animations clés

#### Entrée de carte (fade + slide up)
```css
@keyframes slideUpFade {
  from { opacity: 0; transform: translateY(16px) scale(0.98); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}
.card-enter {
  animation: slideUpFade 400ms var(--ease-decelerate) both;
}
```

#### Apparition de modale (scale + fade)
```css
@keyframes modalAppear {
  from { opacity: 0; transform: scale(0.94) translateY(8px); }
  to   { opacity: 1; transform: scale(1) translateY(0); }
}
```

#### Glow pulse (bouton CTA)
```css
@keyframes glowPulse {
  0%, 100% { box-shadow: 0 0 20px rgba(109,40,217,0.30); }
  50%       { box-shadow: 0 0 40px rgba(109,40,217,0.60); }
}
.btn-cta-glow {
  animation: glowPulse 2s var(--ease-smooth) infinite;
}
```

#### Shimmer (skeleton loading)
```css
@keyframes shimmer {
  0%   { background-position: -200% center; }
  100% { background-position: 200% center; }
}
.skeleton {
  background: linear-gradient(90deg,
    rgba(196,181,253,0.20) 25%,
    rgba(196,181,253,0.50) 50%,
    rgba(196,181,253,0.20) 75%
  );
  background-size: 200% auto;
  animation: shimmer 1.5s linear infinite;
}
```

#### Floating (orbes de fond)
```css
@keyframes float {
  0%, 100% { transform: translateY(0px) scale(1); }
  50%       { transform: translateY(-20px) scale(1.02); }
}
```

### 10.5 Micro-interactions Flutter

| Interaction | Implémentation Flutter |
|---|---|
| Tap ripple glass | `InkWell` avec `splashColor: purple.withOpacity(0.15)` |
| Bouton press | `AnimatedScale` : `0.96` en 100ms + `--ease-spring` retour |
| Card hover | `AnimatedContainer` : élever shadow + translate Y -2px |
| Transition de page | `SlideTransition` + `FadeTransition` combinés, 350ms |
| Bottom sheet | `DraggableScrollableSheet` + `BackdropFilter` |
| Notification toast | Slide from top + fade, `--ease-decelerate` 300ms |
| Like / favori | Scale 0→1.3→1 + particules couleur |
| Chargement | Shimmer + `AnimatedOpacity` pulsante |

### 10.6 Transitions de navigation

```dart
// Transition page avec slide + fade (Flutter)
PageRouteBuilder(
  transitionDuration: Duration(milliseconds: 350),
  pageBuilder: (_, __, ___) => NextScreen(),
  transitionsBuilder: (_, animation, __, child) {
    return SlideTransition(
      position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: FadeTransition(opacity: animation, child: child),
    );
  },
)
```

---

## 11. Illustrations Premium

### 11.1 Style général

- **Style** : illustrations vectorielles **3D isométriques légers** ou **flat 2.5D** avec des couleurs issues de la palette brand.
- **Palette d'illustrations** : violets profonds, lavande, blancs et accents dorés/cyan subtils.
- **Traits** : arrondis, pas d'angles vifs — cohérent avec les `--radius-xl`.
- **Ambiance** : moderne, professionnel, accessible (personnages diversifiés).

### 11.2 Cas d'usage

| Contexte | Type d'illustration | Taille suggérée |
|---|---|---|
| Onboarding (3 slides) | Grande illustration pleine largeur | `100% x 280px` |
| État vide (no data) | Illustration moyenne centrée | `200x200px` |
| Succès / confirmation | Illustration + animation Lottie | `160x160px` |
| Erreur réseau | Illustration medium | `180x180px` |
| Profil non configuré | Illustration guide | `240x160px` |
| Catégories de services | Icônes illustrées par catégorie | `64x64px` |

### 11.3 Sources recommandées

- **Blush.design** — illustrations personnalisables en couleurs brand
- **unDraw** — vectorielles flat, palette adaptable au violet
- **Storyset by Freepik** — style 3D léger, premium
- **Lottiefiles.com** — animations pour succès, loading, onboarding
- **Illustrations Figma Community** — packs cohérents

### 11.4 Règles d'intégration

- Toutes les illustrations doivent utiliser les couleurs de la palette Prestahub (remplacer les couleurs par défaut).
- Fond transparent : les illustrations flottent sur les surfaces glass.
- Format SVG privilégié (scalable, léger) ; PNG@2x pour les complexes.
- En Flutter : utiliser `flutter_svg` pour les SVG, `lottie` pour les animations.

### 11.5 Icônes système

- **Pack** : `Lucide Icons` (cohérent, style line, 24x24px)
- **Style** : line icons, stroke width `1.5px`, arrondis
- **Tailles** : `16px` (inline), `20px` (UI), `24px` (actions), `32px` (featured)
- **Couleur** : toujours via token sémantique (`--color-text`, `--color-primary`, etc.)
- En Flutter : `lucide_icons` package ou SVG custom

---

## 12. Composants Glass — Specs

### 12.1 Bouton primaire

```
Background   : gradient-brand (135deg, #7C3AED → #A78BFA)
Border-radius: --radius-md (12px)
Shadow       : --shadow-glow-sm au repos, --shadow-glow-md au hover
Padding      : 14px 24px
Font         : --font-size-body-lg, weight 600
Hover        : translateY(-1px) + shadow glow intensifié
Active       : scale(0.97) + shadow réduit
```

### 12.2 Card glass

```
Background   : --glass-bg (rgba(255,255,255,0.60))
Backdrop     : blur(16px)
Border       : 1px solid rgba(196,181,253,0.40)
Border-radius: --radius-xl (20px)
Shadow       : --glass-shadow
Reflet       : --shadow-inset-glass
Hover        : translateY(-3px) + shadow intensifié + border plus lumineux
```

### 12.3 Input field glass

```
Background   : rgba(255,255,255,0.50)
Backdrop     : blur(8px)
Border       : 1px solid --color-border
Border-radius: --radius-sm (8px)
Focus border : --color-focus avec --color-focus-ring en box-shadow
Placeholder  : --color-text-subtle
```

### 12.4 Bottom navigation bar

```
Background   : --glass-frosted (rgba(255,255,255,0.85))
Backdrop     : blur(32px)
Border-top   : 1px solid rgba(196,181,253,0.30)
Shadow       : 0 -8px 32px rgba(109,40,217,0.08)
Icône active : couleur --color-primary + dot indicator gradient-brand
Icône inactive: --color-text-subtle
Transition   : 200ms --ease-spring sur l'icône active
```

---

## 13. Layout responsive

### 13.1 Breakpoints

| Token | Valeur | Cible |
|---|---|---|
| `sm` | `< 380px` | Petits mobiles |
| `md` | `380px – 430px` | Mobiles standard |
| `lg` | `430px – 768px` | Grands mobiles / petites tablettes |
| `xl` | `768px – 1024px` | Tablettes |
| `2xl` | `> 1024px` | Web / desktop |

### 13.2 Grille mobile

- Padding horizontal : `--space-4` (16px) sur `sm/md`, `--space-6` (24px) sur `lg+`
- Cards : largeur pleine sur mobile, 2 colonnes sur tablette
- Espacement entre sections : `--space-8` (32px)

---

## 14. Accessibilité

- **Contraste** : minimum 4.5:1 pour le texte normal, 3:1 pour le texte large — vérifier le texte sur glass.
- **Reduced motion** : désactiver toutes les animations non essentielles si `prefers-reduced-motion: reduce`.
- **Taille tactile** : minimum `44x44px` pour toutes les cibles interactives.
- **Focus visible** : ring `--color-focus-ring` bien visible sur tous les éléments.
- **Couleur seule** : ne jamais transmettre une info critique par la couleur uniquement (toujours icône + texte).
- **Blur** : s'assurer que le contenu reste lisible sans l'effet backdrop-filter (fallback).

---

## 15. Livrables attendus

- [ ] Fichier Figma avec variables/tokens et composants glass
- [ ] Fichier de tokens Flutter (`theme_tokens.dart`) + `ThemeData`
- [ ] Pack d'illustrations onboarding (3 écrans)
- [ ] Pack d'illustrations états vides (5 contextes)
- [ ] Animations Lottie : succès, erreur, chargement
- [ ] Bibliothèque d'icônes intégrée (Lucide)
- [ ] Guide d'utilisation des animations (do/don't)
