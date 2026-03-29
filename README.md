# Bananasplit – Reiseplaner

**Bananasplit** ist eine Flutter-App, die Reisegruppen dabei hilft, ihre Reisen gemeinsam zu organisieren – von der Planung bis zur Abrechnung.

---

## Funktionen

### Reisegruppen
- Erstelle und verwalte Reisegruppen mit beliebig vielen Mitgliedern
- Lege Reiseziel, Startdatum und Enddatum fest
- Bearbeite Gruppendetails jederzeit

### Ausgaben & Geldaufteilung
- Erfasse gemeinsame Ausgaben (Transaktionen) innerhalb der Gruppe
- Wähle, wer bezahlt hat und wer beteiligt ist
- Automatische Saldo-Berechnung: Wer schuldet wem wie viel?
- Übersichtliche Darstellung aller offenen Beträge pro Person

### Eventplanung
- Plane Events und Aktivitäten für die Reise
- Vergib Titel, Datum und Ort
- Vergangene und zukünftige Events werden getrennt dargestellt

### Notizen
- Lege Notizen für die Gruppe an (z. B. Packlisten, Infos, To-Dos)
- Checklisten-Format mit abhakbaren Punkten (`- [ ]`)
- Notizen bearbeiten und löschen

### Übersicht (Dashboard)
- Schnellübersicht über deinen persönlichen Saldo
- Countdown bis zum Reisestart oder -ende
- Anzahl geplanter Events auf einen Blick

---

## Tech Stack

- **Flutter** (Dart)
- **Provider** für State Management
- **REST API** (Spring Boot Backend)
- Unterstützt Android, iOS & Web

---

## Setup

```bash
flutter pub get
flutter run
```

- Stell sicher, dass das Backend unter der konfigurierten URL erreichbar ist.
- Backend für Testzwecke unter http://ubuntu.p-stephan.de:8081/ erreichbar. 
- Aktuellste Version des Frontends meist unter https://github.com/Phimance/Reiseplaner-Frontend zu finden.
- Aktuellste Version des Backends meist unter https://github.com/Phimance/Reiseplaner-Backend zu finden.
---
