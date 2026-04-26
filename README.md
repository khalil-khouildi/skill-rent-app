# 🛠️ Skill Rent

> Plateforme mobile de mise en relation entre clients et freelancers pour des missions ponctuelles à la demande — avec IA, carte interactive et statistiques visuelles.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Backend-orange?logo=firebase)
![Firestore](https://img.shields.io/badge/Firestore-Database-yellow?logo=firebase)
![Google Maps](https://img.shields.io/badge/Google%20Maps-Géoloc-green?logo=googlemaps)
![Claude AI](https://img.shields.io/badge/Claude%20AI-Anthropic-purple)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📋 Table des matières

- [Présentation](#-présentation)
- [Nouveautés](#-nouveautés)
- [Fonctionnalités](#-fonctionnalités)
- [Stack Technique](#-stack-technique)
- [Architecture](#-architecture)
- [Installation](#-installation)
- [Configuration Firebase](#-configuration-firebase)
- [Configuration Google Maps](#-configuration-google-maps)
- [Configuration Claude AI](#-configuration-claude-ai)
- [Graphiques fl_chart](#-graphiques----fl_chart)
- [Screens](#-screens-17-écrans)
- [Parcours utilisateurs](#-parcours-utilisateurs)
- [Scénario de démo](#-scénario-de-démo-7-min)
- [Métriques](#-métriques-du-projet)
- [Évolutions futures](#-évolutions-futures)
- [Équipe](#-équipe)

---

## 🎯 Présentation

**Skill Rent** répond à une problématique concrète :

> *"Difficulté pour de nombreuses personnes à valoriser rapidement leurs compétences, ainsi que le besoin croissant de services ponctuels, accessibles immédiatement."*

### La solution

Une application mobile Flutter qui connecte en temps réel :
- 👤 **Clients** — publient des demandes de services
- 💼 **Freelancers** — postulent et réalisent les missions
- 🤖 **IA Claude** — génère automatiquement titre et description des annonces
- 🗺️ **Carte Google Maps** — visualise les missions autour de soi
- 📊 **Graphiques fl_chart** — suit ses statistiques en temps réel

---

## 🆕 Nouveautés

### 🤖 IA — Génération automatique de titre et description

Lors de la publication d'une demande, l'utilisateur peut activer l'IA :

```
L'utilisateur saisit quelques mots-clés :
"réparer vélo, roue cassée, urgent"
              ↓
Claude AI génère automatiquement :
Titre       → "Réparation urgente de roue de vélo"
Description → "Je cherche un technicien vélo disponible
               rapidement pour réparer une roue endommagée.
               Intervention souhaitée aujourd'hui si possible."
              ↓
L'utilisateur modifie ou valide directement
```

**Avantages :**
- ✅ Annonces mieux rédigées = plus de candidatures
- ✅ Gain de temps pour le client
- ✅ Cohérence du contenu sur la plateforme

---

### 🗺️ Carte Interactive — Google Maps

**1. Feed carte (onglet map)**
```
Vue carte de toutes les demandes ouvertes
├── Markers colorés par catégorie
├── Tap sur marker → aperçu de la demande
├── Filtres actifs sur la carte
└── Centré sur la position de l'utilisateur
```

**2. Sélection de localisation lors de la publication**
```
├── Drag & drop du marker sur la carte
├── Géocodage automatique → adresse textuelle
└── Sauvegarde des coordonnées GPS (lat/lng)
```

---

### 📊 Graphiques — Statistiques visuelles

| Graphique | Type | Données |
|---|---|---|
| Missions par mois | Bar chart | Historique 6 mois |
| Évolution de la note | Line chart | Note moyenne dans le temps |
| Répartition catégories | Pie chart | Types de missions réalisées |
| Revenus (freelancer) | Bar chart | Gains par semaine |
| Taux de succès | Progress indicator | Missions acceptées / postulées |

---

## ✅ Fonctionnalités

### Essentielles (toutes implémentées)

| Fonctionnalité | Statut | Description |
|---|---|---|
| Gestion des utilisateurs | ✅ | Inscription, connexion, rôles Client/Freelancer |
| Publication et consultation | ✅ | Publier des demandes + recherche/filtres |
| Interaction entre utilisateurs | ✅ | Postuler, accepter/refuser, messagerie temps réel |
| Système d'évaluation | ✅ | Notation (1-5 ⭐) + avis écrits |
| Interface intuitive | ✅ | UI moderne avec Google Fonts Inter |

### Avancées (toutes implémentées)

| Fonctionnalité | Statut | Description |
|---|---|---|
| 🤖 IA génération annonce | ✅ | Claude API génère titre + description |
| 🗺️ Carte interactive | ✅ | Google Maps — missions + localisation |
| 📊 Graphiques statistiques | ✅ | fl_chart — bar, line, pie charts |
| 💬 Messagerie temps réel | ✅ | Chat avec indicateurs de lecture |
| 🔍 Recommandation | ✅ | Filtres catégorie + recherche mot-clé |

### À venir

| Fonctionnalité | Priorité |
|---|---|
| Système de paiement (Stripe) | 🔴 Haute |
| Notifications push | 🟡 Moyenne |
| IA matching automatique | 🟡 Moyenne |

---

## 🛠️ Stack Technique

| Catégorie | Technologie | Justification |
|---|---|---|
| **Frontend** | Flutter 3.x | Multiplateforme Android/iOS |
| **Backend** | Firebase | Temps réel, scalable, gratuit |
| **Base de données** | Firestore | Requêtes temps réel |
| **Auth** | Firebase Auth | Sécurisé, prêt à l'emploi |
| **Carte** | Google Maps Flutter | Carte native, markers, géocodage |
| **IA** | Claude API (Anthropic) | Génération titre + description |
| **Graphiques** | fl_chart | Charts Flutter natifs |
| **Gestion d'état** | Provider | Simple, natif Flutter |

---

## 🏗️ Architecture

```
skill_rent/
│
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   │
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── request_model.dart          ← lat, lng ajoutés
│   │   ├── application_model.dart
│   │   ├── message_model.dart
│   │   └── review_model.dart
│   │
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── request_service.dart
│   │   ├── application_service.dart
│   │   ├── message_service.dart
│   │   ├── review_service.dart
│   │   ├── ai_service.dart             ← 🆕 Claude API
│   │   ├── maps_service.dart           ← 🆕 Google Maps + Geocoding
│   │   └── stats_service.dart          ← 🆕 Calcul statistiques
│   │
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── request_provider.dart
│   │   └── stats_provider.dart         ← 🆕
│   │
│   └── screens/
│       ├── auth/
│       │   ├── login_screen.dart
│       │   └── register_screen.dart
│       ├── home/
│       │   ├── home_screen.dart
│       │   ├── feed_list_screen.dart
│       │   └── feed_map_screen.dart    ← 🆕 Vue carte
│       ├── requests/
│       │   ├── post_request_screen.dart  ← 🆕 + IA + carte
│       │   ├── request_detail_screen.dart
│       │   └── my_requests_screen.dart
│       ├── applications/
│       │   ├── apply_screen.dart
│       │   └── my_applications_screen.dart
│       ├── chat/
│       │   ├── inbox_screen.dart
│       │   └── chat_screen.dart
│       ├── profile/
│       │   ├── profile_screen.dart     ← 🆕 + graphiques
│       │   ├── edit_profile_screen.dart
│       │   └── stats_screen.dart       ← 🆕 Dashboard stats
│       ├── reviews/
│       │   └── review_screen.dart
│       └── map/
│           └── map_picker_screen.dart  ← 🆕 Sélection localisation
│
├── pubspec.yaml
├── .env
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
├── role              (client | freelancer)
├── bio
├── skills[]
├── rating
├── missions_count
├── total_earnings    ← 🆕
└── created_at

requests
├── id
├── client_id
├── title
├── description
├── category
├── budget
├── location          (adresse textuelle)
├── lat               ← 🆕 latitude GPS
├── lng               ← 🆕 longitude GPS
├── ai_generated      ← 🆕 boolean (généré par IA ?)
├── status            (open | in_progress | done | closed)
└── created_at

applications
├── id
├── request_id
├── freelancer_id
├── message
├── price_offer
└── status            (pending | accepted | rejected)

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
├── rating            (1-5)
└── comment
```

---

## ⚙️ Installation

### Prérequis

```bash
flutter --version   # >= 3.0.0
dart --version      # >= 3.0.0
npm install -g firebase-tools
```

### Cloner et installer

```bash
git clone https://github.com/[username]/skill-rent.git
cd skill-rent
flutter pub get
```

### Variables d'environnement

Créer un fichier `.env` à la racine :

```env
CLAUDE_API_KEY=sk-ant-xxxxxxxxxxxxxxxx
GOOGLE_MAPS_API_KEY=AIzaxxxxxxxxxxxxxxxx
```

### Lancer l'application

```bash
flutter run              # Android/iOS
flutter run -d chrome    # Web (demo)
```

---

## 🔥 Configuration Firebase

### 1. Créer le projet

```
Firebase Console → Nouveau projet → "skill-rent"
Activer : Authentication + Firestore + Storage
```

### 2. FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Règles Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    match /requests/{requestId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.client_id;
    }

    match /applications/{appId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth.uid == resource.data.freelancer_id
                    || request.auth.uid == get(/databases/$(database)/documents/
                       requests/$(resource.data.request_id)).data.client_id;
    }

    match /messages/{messageId} {
      allow read, write: if request.auth != null;
    }

    match /reviews/{reviewId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

---

## 🗺️ Configuration Google Maps

### 1. Activer les APIs Google Cloud

```
Google Cloud Console → APIs :
✅ Maps SDK for Android
✅ Maps SDK for iOS
✅ Geocoding API
✅ Places API
```

### 2. Android — AndroidManifest.xml

```xml
<manifest>
  <application>
    <meta-data
      android:name="com.google.android.geo.API_KEY"
      android:value="${GOOGLE_MAPS_API_KEY}"/>
  </application>
</manifest>
```

### 3. iOS — AppDelegate.swift

```swift
import GoogleMaps
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

### 4. maps_service.dart

```dart
class MapsService {

  // Géocodage : adresse → coordonnées GPS
  Future<LatLng?> addressToLatLng(String address) async {
    final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?address=${Uri.encodeComponent(address)}'
      '&key=$googleMapsApiKey'
    ));
    final data = jsonDecode(response.body);
    final loc = data['results'][0]['geometry']['location'];
    return LatLng(loc['lat'], loc['lng']);
  }

  // Construire les markers pour les demandes
  Set<Marker> buildMarkers(List<RequestModel> requests) {
    return requests.map((r) => Marker(
      markerId: MarkerId(r.id),
      position: LatLng(r.lat, r.lng),
      infoWindow: InfoWindow(
        title: r.title,
        snippet: '${r.budget}€ — ${r.category}',
      ),
    )).toSet();
  }
}
```

---

## 🤖 Configuration Claude AI

### 1. Obtenir une clé API

```
https://console.anthropic.com → API Keys → Create Key
```

### 2. ai_service.dart

```dart
class AIService {
  static const _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const _apiKey = String.fromEnvironment('CLAUDE_API_KEY');

  Future<Map<String, String>> generatePostContent(String keywords) async {
    final prompt = '''
Tu es un assistant pour une plateforme de services à la demande.
L'utilisateur veut publier une demande avec ces mots-clés : "$keywords"

Génère en JSON uniquement :
{
  "title": "titre court et clair (max 60 caractères)",
  "description": "description professionnelle et précise (max 200 caractères)"
}

Réponds UNIQUEMENT avec le JSON, sans texte supplémentaire.
''';

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-sonnet-4-20250514',
        'max_tokens': 300,
        'messages': [{'role': 'user', 'content': prompt}],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['content'][0]['text'];
      final json = jsonDecode(text);
      return {
        'title': json['title'] ?? '',
        'description': json['description'] ?? '',
      };
    }
    throw Exception('Erreur API Claude : ${response.statusCode}');
  }
}
```

### 3. Bouton IA dans post_request_screen.dart

```dart
// Bouton Générer avec IA
ElevatedButton.icon(
  onPressed: _isGenerating ? null : _generateWithAI,
  icon: _isGenerating
    ? SizedBox(width: 16, height: 16,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
    : Icon(Icons.auto_awesome),
  label: Text(_isGenerating ? 'Génération en cours...' : '✨ Générer avec IA'),
  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
),

// Handler
Future<void> _generateWithAI() async {
  if (_keywordsController.text.trim().isEmpty) return;
  setState(() => _isGenerating = true);
  try {
    final result = await AIService()
        .generatePostContent(_keywordsController.text);
    setState(() {
      _titleController.text = result['title']!;
      _descriptionController.text = result['description']!;
    });
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Erreur IA : $e')));
  } finally {
    setState(() => _isGenerating = false);
  }
}
```

---

## 📊 Graphiques — fl_chart

```dart
// Bar chart — Missions par mois
BarChart(
  BarChartData(
    barGroups: monthlyData.map((data) => BarChartGroupData(
      x: data.month,
      barRods: [BarChartRodData(
        toY: data.count.toDouble(),
        color: Colors.deepPurple,
        width: 16,
        borderRadius: BorderRadius.circular(4),
      )],
    )).toList(),
  ),
)

// Line chart — Évolution de la note
LineChart(
  LineChartData(
    lineBarsData: [LineChartBarData(
      spots: ratingHistory.map((r) =>
        FlSpot(r.weekIndex.toDouble(), r.rating)
      ).toList(),
      isCurved: true,
      color: Colors.amber,
      dotData: FlDotData(show: true),
    )],
  ),
)

// Pie chart — Répartition par catégorie
PieChart(
  PieChartData(
    sections: categories.map((c) => PieChartSectionData(
      value: c.count.toDouble(),
      title: c.name,
      color: c.color,
      radius: 80,
    )).toList(),
  ),
)
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

  # 🆕 Google Maps
  google_maps_flutter: ^2.5.3
  geocoding: ^2.1.1
  geolocator: ^11.0.0

  # 🆕 Graphiques
  fl_chart: ^0.66.2

  # 🆕 IA — HTTP pour Claude API
  http: ^1.2.0

  # Utils
  intl: ^0.19.0
  image_picker: ^1.0.7
  uuid: ^4.3.3
  flutter_dotenv: ^5.1.0
```

---

## 📱 Screens (17 écrans)

| # | Écran | Rôle | |
|---|---|---|---|
| 1 | Splash Screen | Chargement + vérification auth | |
| 2 | Login | Connexion email/password | |
| 3 | Register | Inscription + choix du rôle | |
| 4 | Feed Liste | Demandes disponibles en liste | |
| 5 | Feed Carte | Demandes sur Google Maps | 🆕 |
| 6 | Post Request | Publier + IA + carte | 🆕 |
| 7 | Map Picker | Sélectionner une localisation | 🆕 |
| 8 | Request Detail | Détail + liste candidatures | |
| 9 | My Requests | Mes demandes (client) | |
| 10 | Apply Screen | Postuler avec message + prix | |
| 11 | My Applications | Mes candidatures (freelancer) | |
| 12 | Inbox | Liste des conversations | |
| 13 | Chat Screen | Messagerie temps réel | |
| 14 | Profile | Profil public + graphiques | 🆕 |
| 15 | Stats Dashboard | Dashboard complet graphiques | 🆕 |
| 16 | Edit Profile | Modifier mes infos | |
| 17 | Review Screen | Laisser un avis après mission | |

---

## 🔄 Parcours utilisateurs

### 👤 Client

```
Inscription (rôle Client)
       ↓
Publier une demande
├── Saisit des mots-clés
├── 🤖 Clique "Générer avec IA"
│   └── Titre + description auto-générés
├── 🗺️ Sélectionne la localisation sur la carte
└── Publie
       ↓
Recevoir des candidatures
       ↓
Accepter un freelancer
       ↓
Chat + coordination
       ↓
Valider mission terminée
       ↓
Laisser un avis ⭐
       ↓
📊 Voir ses stats sur le dashboard
```

### 💼 Freelancer

```
Inscription (rôle Freelancer)
       ↓
Parcourir les demandes
├── 📋 Vue liste avec filtres
└── 🗺️ Vue carte — markers par catégorie
       ↓
Postuler (message + offre de prix)
       ↓
Attendre la réponse du client
       ↓
Chat + réaliser la mission
       ↓
Recevoir un avis ⭐
       ↓
📊 Dashboard — évolution note + revenus + missions
```

---

## 🎬 Scénario de démo (7 min)

```
0:00 → Splash screen + ouverture app
0:30 → Création compte Client
1:00 → Post Request — saisie mots-clés
1:30 → 🤖 Génération IA → titre + description auto
2:00 → 🗺️ Sélection localisation sur carte
2:30 → Publication de la demande
3:00 → Déconnexion → Connexion Freelancer
3:20 → 🗺️ Vue carte — voir les missions autour
3:40 → Postuler sur la demande
4:00 → Client voit et accepte le freelancer
4:20 → Chat en temps réel
4:40 → Client valide + note ⭐⭐⭐⭐⭐
5:00 → 📊 Dashboard — graphiques stats freelancer
5:30 → Bar chart missions + Line chart note + Pie chart catégories
6:00 → Fin
```

---

## 📊 Métriques du projet

| Métrique | Valeur |
|---|---|
| Screens | 17 écrans |
| Services Firebase | 5 services |
| Collections Firestore | 6 collections |
| APIs externes | 3 (Firebase, Google Maps, Claude AI) |
| Lignes de code | ~4 500 |
| Temps de développement | 10 heures |

---

## 🚀 Évolutions futures

| Fonctionnalité | Impact | Difficulté |
|---|---|---|
| Paiement intégré (Stripe) | 🔴 Élevé | Moyenne |
| Notifications push | 🟡 Élevé | Moyenne |
| Mode hors ligne | 🟢 Moyen | Moyenne |

---




## 📄 License

MIT License — libre d'utilisation et de modification

---

<div align="center">

**Skill Rent** — *Valorise tes compétences, trouve de l'aide, maintenant.*

🤖 Powered by Claude AI &nbsp;|&nbsp; 🗺️ Google Maps &nbsp;|&nbsp; 🔥 Firebase &nbsp;|&nbsp; 📊 fl_chart

Made with ❤️ during a 10h hackathon

</div>
