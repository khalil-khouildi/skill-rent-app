# 🛠️ Skill Rent

> Plateforme mobile de mise en relation entre clients et freelancers pour des missions ponctuelles à la demande.

---

## 📋 Table des matières

- [Présentation](#-présentation)
- [Fonctionnalités](#-fonctionnalités)
- [Stack Technique](#-stack-technique)
- [Architecture](#-architecture)
- [Installation](#-installation)
- [Configuration Firebase](#-configuration-firebase)
- [Structure du projet](#-structure-du-projet)
- [Screens](#-screens)
- [Parcours utilisateurs](#-parcours-utilisateurs)
- [Métriques](#-métriques)
- [Évolutions futures](#-évolutions-futures)
- [Équipe](#-équipe)

---

## 🎯 Présentation

**Skill Rent** répond à une problématique concrète :

> *"Difficulté pour de nombreuses personnes à valoriser rapidement leurs compétences, ainsi que le besoin croissant de services ponctuels, accessibles immédiatement."*

### La solution

Une application mobile Flutter qui connecte en temps réel :
- 👤 **Clients** — qui publient des demandes de services
- 💼 **Freelancers** — qui postulent et réalisent les missions

---

## ✅ Fonctionnalités

### Essentielles (toutes implémentées)

| Fonctionnalité | Statut | Description |
|---|---|---|
| Gestion des utilisateurs | ✅ | Inscription, connexion, rôles (Client/Freelancer) |
| Publication et consultation | ✅ | Publier des demandes + parcourir avec recherche/filtres |
| Interaction entre utilisateurs | ✅ | Postuler, accepter/refuser, messagerie temps réel |
| Système d'évaluation | ✅ | Notation (1-5 ⭐) + avis écrits |
| Interface intuitive | ✅ | UI moderne avec Google Fonts Inter |

### Avancées (implémentées)

| Fonctionnalité | Statut | Description |
|---|---|---|
| Messagerie temps réel | ✅ | Chat avec indicateurs de lecture |
| Recommandation personnalisée | ✅ | Filtres par catégorie + recherche par mot-clé |
| Statistiques utilisateur | ✅ | Missions complétées, note moyenne, taux de succès |

### À venir

| Fonctionnalité | Priorité |
|---|---|
| Intelligence artificielle (matching) | 🔴 Haute |
| Géolocalisation | 🔴 Haute |
| Système de paiement (Stripe) | 🔴 Haute |

---

## 🛠️ Stack Technique

| Catégorie | Technologie | Justification |
|---|---|---|
| **Frontend** | Flutter 3.x | Multiplateforme Android/iOS avec un seul code |
| **Backend** | Firebase | Rapide à mettre en place, temps réel, gratuit |
| **Base de données** | Firestore | Requêtes en temps réel, évolutif |
| **Authentification** | Firebase Auth | Sécurisé, prêt à l'emploi |
| **Gestion d'état** | Provider | Simple, natif Flutter |

---

## 🏗️ Architecture

```
skill_rent/
│
├── lib/
│   ├── main.dart                  # Point d'entrée
│   ├── firebase_options.dart      # Config Firebase
│   │
│   ├── models/                    # Modèles de données
│   │   ├── user_model.dart
│   │   ├── request_model.dart
│   │   ├── application_model.dart
│   │   ├── message_model.dart
│   │   └── review_model.dart
│   │
│   ├── services/                  # Logique métier Firebase
│   │   ├── auth_service.dart
│   │   ├── request_service.dart
│   │   ├── application_service.dart
│   │   ├── message_service.dart
│   │   └── review_service.dart
│   │
│   ├── providers/                 # Gestion d'état (Provider)
│   │   ├── auth_provider.dart
│   │   └── request_provider.dart
│   │
│   └── screens/                   # 14 écrans UI
│       ├── auth/
│       │   ├── login_screen.dart
│       │   └── register_screen.dart
│       ├── home/
│       │   └── home_screen.dart
│       ├── requests/
│       │   ├── feed_screen.dart
│       │   ├── post_request_screen.dart
│       │   ├── request_detail_screen.dart
│       │   └── my_requests_screen.dart
│       ├── applications/
│       │   ├── apply_screen.dart
│       │   └── my_applications_screen.dart
│       ├── chat/
│       │   ├── inbox_screen.dart
│       │   └── chat_screen.dart
│       ├── profile/
│       │   ├── profile_screen.dart
│       │   └── edit_profile_screen.dart
│       └── reviews/
│           └── review_screen.dart
│
├── pubspec.yaml
├── firebase.json
└── README.md
```

---

## 🗄️ Collections Firestore

```
users
├── uid
├── name
├── email
├── avatar_url
├── role          (client | freelancer)
├── bio
├── skills[]
├── rating
├── missions_count
└── created_at

requests
├── id
├── client_id
├── title
├── description
├── category
├── budget
├── location
├── status        (open | in_progress | done | closed)
└── created_at

applications
├── id
├── request_id
├── freelancer_id
├── message
├── price_offer
└── status        (pending | accepted | rejected)

conversations
├── id
├── request_id
├── client_id
└── freelancer_id

messages
├── id
├── conversation_id
├── sender_id
├── content
├── is_read
└── created_at

reviews
├── id
├── reviewer_id
├── reviewed_id
├── request_id
├── rating        (1-5)
└── comment
```

---

## ⚙️ Installation

### Prérequis

```bash
# Flutter SDK
flutter --version   # >= 3.0.0

# Dart SDK
dart --version      # >= 3.0.0

# Firebase CLI
npm install -g firebase-tools
firebase --version
```

### Cloner le projet

```bash
git clone https://github.com/[username]/skill-rent.git
cd skill-rent
```

### Installer les dépendances

```bash
flutter pub get
```

### Lancer l'application

```bash
# Android
flutter run

# iOS
flutter run -d ios

# Web (demo)
flutter run -d chrome
```

---

## 🔥 Configuration Firebase

### 1. Créer un projet Firebase

```
Firebase Console → Nouveau projet → "skill-rent"
```

### 2. Activer les services

```
✅ Authentication (Email/Password)
✅ Firestore Database
✅ Storage (pour les avatars)
```

### 3. Configurer FlutterFire

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 4. Règles Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    // Requests
    match /requests/{requestId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.client_id;
    }

    // Applications
    match /applications/{appId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth.uid == resource.data.freelancer_id
                    || request.auth.uid == get(/databases/$(database)/documents/requests/$(resource.data.request_id)).data.client_id;
    }

    // Messages
    match /messages/{messageId} {
      allow read, write: if request.auth != null;
    }

    // Reviews
    match /reviews/{reviewId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

---

## 📦 Dépendances (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0

  # State Management
  provider: ^6.1.1

  # UI
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.1
  flutter_rating_bar: ^4.0.1

  # Utils
  intl: ^0.19.0
  image_picker: ^1.0.7
  uuid: ^4.3.3
```

---

## 📱 Screens (14 écrans)

| # | Écran | Rôle |
|---|---|---|
| 1 | Splash Screen | Chargement + vérification auth |
| 2 | Login | Connexion email/password |
| 3 | Register | Inscription + choix du rôle |
| 4 | Home / Feed | Liste des demandes disponibles |
| 5 | Post Request | Publier une nouvelle demande |
| 6 | Request Detail | Détail + liste des candidatures |
| 7 | My Requests | Mes demandes publiées (client) |
| 8 | Apply Screen | Postuler avec message + prix |
| 9 | My Applications | Mes candidatures (freelancer) |
| 10 | Inbox | Liste des conversations |
| 11 | Chat Screen | Messagerie temps réel |
| 12 | Profile | Profil public + stats |
| 13 | Edit Profile | Modifier mes infos |
| 14 | Review Screen | Laisser un avis après mission |

---

## 🔄 Parcours utilisateurs

### 👤 Client

```
Inscription (rôle Client)
       ↓
Publier une demande
(titre, description, budget, localisation)
       ↓
Recevoir des candidatures
       ↓
Accepter le meilleur freelancer
       ↓
Chat + coordination
       ↓
Valider la mission terminée
       ↓
Laisser un avis ⭐
```

### 💼 Freelancer

```
Inscription (rôle Freelancer)
       ↓
Parcourir les demandes
(recherche + filtres par catégorie)
       ↓
Postuler (message + offre de prix)
       ↓
Attendre la réponse du client
       ↓
Chat + réaliser la mission
       ↓
Recevoir un avis ⭐
(améliore son score de réputation)
```

---

## 🎬 Scénario de démo (5 min)

```
0:00 → Splash screen + ouverture app
0:30 → Création compte Client
1:00 → Publication d'une demande
1:30 → Déconnexion → Connexion Freelancer
2:00 → Parcourir et postuler
2:30 → Client voit la candidature
3:00 → Client accepte le freelancer
3:30 → Chat en temps réel
4:00 → Client complète et note ⭐⭐⭐⭐⭐
4:30 → Freelancer voit sa note augmenter
5:00 → Fin
```

---

## 📊 Métriques du projet

| Métrique | Valeur |
|---|---|
| Screens | 14 écrans |
| Services Firebase | 5 services |
| Collections Firestore | 6 collections |
| Lignes de code | ~3 500 |
| Temps de développement | 10 heures |

---



## 📄 License

```
MIT License — libre d'utilisation et de modification
```

---

<div align="center">

**Skill Rent** — *Valorise tes compétences, trouve de l'aide, maintenant.*

Made with ❤️ during a 10h hackathon

</div>
