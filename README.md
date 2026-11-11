# 🍌 Bananasplit – Reiseplaner

<div align="center">
  <img src="./assets/images/bananasplit_logo.png" alt="Bananasplit Logo" height="120" />
  <p><em>Zusammen auf Reisen – gemeinsam verrechnen</em></p>
</div>

[![Flutter Version](https://img.shields.io/badge/Flutter-3.24-blue.svg)](https://flutter.dev)
[![Dart SDK](https://img.shields.io/badge/Dart-3.10-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Bananasplit** ist eine moderne Flutter-App, die Reisegruppen dabei hilft, ihre Reisen gemeinsam zu organisieren – von der Planung bis zur Abrechnung. Plane Events, tracke Ausgaben und halte den Überblick über offene Beträge.

---

## ✨ Features

### 📱 Reisegruppen
- Erstelle und verwalte Reisegruppen mit beliebig vielen Mitgliedern
- Lege Reiseziel, Startdatum und Enddatum fest
- Gruppendetails jederzeit bearbeiten
- Einladungssystem für neue Mitglieder

### 💰 Ausgaben & Geldaufteilung
- Erfasse gemeinsame Ausgaben (Transaktionen) innerhalb der Gruppe
- Wähle aus, wer bezahlt hat und wer beteiligt ist
- Automatische Saldo-Berechnung: Wer schuldet wem wie viel?
- Übersichtliche Darstellung aller offenen Beträge pro Person

### 📅 Eventplanung
- Plane Events und Aktivitäten für die Reise
- Vergib Titel, Datum, Ort und Beschreibung
- Getrennte Ansichten für vergangene und zukünftige Events

### 📝 Notizen & To-Dos
- Lege strukturierte Notizen für die Gruppe an (z. B. Packlisten)
- Checklisten-Format mit abhakbaren Punkten (`- [ ]`)
- Einfach bearbeiten und löschen

### 📊 Dashboard Übersicht
- Schnellübersicht über deinen persönlichen Saldo
- Countdown bis zum Reisestart oder -ende
- Anzahl geplanter Events auf einen Blick

---

## 🛠️ Tech Stack

| Layer     | Technologie                    | Beschreibung                    |
|-----------|--------------------------------|----------------------------------|
| **Frontend**   | Flutter (Dart)                 | Cross-platform UI Framework    |
| **State Mgmt** | Provider                       | State Management & Navigation  |
| **Networking** | `http`                         | API-Kommunikation              |
| **Assets**     | `flutter_svg`, `shared_preferences` | SVG-Support, Local Storage   |
| **Backend**    | Spring Boot                    | REST API                        |

### 📦 Dependencies (Frontend)
- `provider`: State Management
- `http`: REST API Communication
- `intl`: Datums- und Währungsdarstellung
- `flutter_svg`: SVG-Bilderunterstützung
- `shared_preferences`: Lokaler Speicher

---

## 🚀 Setup & Installation

### Voraussetzungen

- **Flutter SDK** >= 3.10.8 ([Download](https://docs.flutter.dev/get-started/install))
- **Dart SDK** >= 3.10 ([Download](https://dart.dev/get-dart))
- IDE mit Flutter Support (VS Code, Android Studio, etc.)

### Installation

```bash
# Dependencies laden
flutter pub get

# App starten
flutter run
```

### Platform-spezifische Einrichtung

#### 📱 Android
```bash
flutter run -d android
```
**Voraussetzungen:**
- Android SDK & Emulator oder reales Gerät
- Java Development Kit (JDK) >= 11
- Android Studio (empfohlen)

#### 🍎 iOS (macOS only)
```bash
flutter run -d ios
```
**Voraussetzungen:**
- macOS mit Xcode installiert
- CocoaPods für Abhängigkeiten (`pod install` im `ios/Pods/` Verzeichnis)

#### 🌐 Web
```bash
flutter run -d chrome
```
**Voraussetzungen:**
- Chrome Browser (für Entwicklung)
- Optional: Local Server mit `flutter build web` und Live-Reload

#### 🖥️ Desktop (Linux, Windows, macOS)
```bash
flutter run -d windows  # oder linux / macos
```
**Hinweis:** Desktop-Apps benötigen native Bibliotheken für den Zugriff auf Systemfeatures.

---

## 🔗 Backend Konfiguration

### Entwicklungsumgebung

Das Frontend verbindet sich standardmäßig mit dem Test-Backend:
- **URL:** `http://ubuntu.p-stephan.de:8081/`
- Für lokale Entwicklung: API_URL in der App anpassen oder `.env` nutzen

### Produktion

Die aktuelle Version des Frontends findet man unter:
- 🔗 [Reiseplaner-Frontend](https://github.com/Phimance/Reiseplaner-Frontend)

Das Backend ist hier verfügbar:
- 🔗 [Reiseplaner-Backend](https://github.com/Phimance/Reiseplaner-Backend)

---

## 📋 Open Issues

Aktuelle zu bearbeitende Aufgaben im Repository:

| #     | Titel                              | Status   |
|-------|------------------------------------|----------|
| #35   | Saldo feature hinzufügen           | Open     |
| #32   | HomeScreen: Tage/Nächte Anzeige    | Open     |
| #30   | HomeScreen: Events nicht angezeigt | Open     |
| #23   | Join Group Feature                 | Open     |
| #16   | Ausgaben Page UI                   | Open     |
| #12   | Backend: Activity/Event            | Open     |
| #4    | TransactionPage UI                 | Open     |

🔍 [Alle Issues ansehen auf GitHub](https://github.com/Phimance/Reiseplaner-Frontend/issues)

---

## 🤝 Contributing

Wir freuen uns über Beiträge! Hier ist, wie du mithelfen kannst:

### 1. Fork & Clone
```bash
git clone https://github.com/<dein-user>/Reiseplaner-Frontend.git
cd Reiseplaner-Frontend
```

### 2. Branch erstellen
```bash
git checkout -b feature/DeinFeatureName
```

### 3. Änderungen vornehmen & testen
```bash
flutter pub get
flutter test
```

### 4. Commit & Push
```bash
git commit -m "feat: Dein Feature"
git push origin feature/DeinFeatureName
```

### 5. Pull Request öffnen

Erstelle einen Pull Request mit einer klaren Beschreibung der Änderungen.

---

## 📂 Projektstruktur

```
Reiseplaner-Frontend/
├── lib/                 # Haupt-Quellcode (Flutter)
│   ├── main.dart       # App-Einstiegspunkt
│   ├── screens/        # UI-Bildschirme
│   └── models/         # Datenmodelle
├── assets/             # Bild-, Audio- und andere Assets
│   ├── icons/          # Icons für die App
│   └── images/         # Bilddateien
├── test/               # Unit & Widget Tests
├── pubspec.yaml        # Flutter Dependencies
└── README.md           # Diese Datei
```

---

## 📄 Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Details in der [LICENSE](LICENSE)-Datei.

---

<div align="center">
  <p>Made with ❤️ by the Bananasplit Team</p>
  <p><a href="https://github.com/Phimance" target="_blank">👤 Phimance</a> | 
  <a href="#" target="_blank">🐦 X (Twitter)</a> | 
  <a href="#" target="_blank">💬 Discord</a></p>
</div>

---

<div align="center">
  <!-- Optional: Social Links -->
  <img src="./assets/images/bananasplit_screenshot.png" alt="App Screenshot" width="300" />
</div>

---

*Zusammen auf Reisen – gemeinsam verrechnen!* 🌍✈️