# 🍌 Bananasplit – Reiseplaner

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Bananasplit ist eine moderne Frontend-Lösung für den Reiseplaner. Es bietet eine intuitive Benutzeroberfläche und leistungsstarke Funktionen für die Planung von Reisen.

## Features

- Modernes UI/UX Design
- Hohe Performance
- Responsive Design (Mobile-first)
- Sichere Datenverarbeitung
- Mehrsprachige Unterstützung

## Getting Started

Dieser Abschnitt enthält Informationen zum Starten des Projekts.

### Voraussetzungen

Stelle sicher, dass folgende Tools installiert sind:

- Node.js >= 18.x
- npm oder yarn
- Git

### Quick Start

```bash
git clone https://github.com/Phimance/Reiseplaner-Frontend.git
cd Reiseplaner-Frontend
npm install
npm run dev
```

## Installation

Für eine Produktionsumgebung:

```bash
npm install --production
# oder
yarn install --production
```

## Configuration

Konfiguriere das Projekt in `src/config.json`:

```json
{
  "apiUrl": "https://api.reiseplaner.com",
  "theme": "default",
  "language": "de"
}
```

## Usage

Das Grundgerüst zur Verwendung von Bananasplit:

1. Importiere die Hauptkomponente
2. Initialisiere den App-Container
3. Konfiguriere die Einstellungen

```typescript
import { ReiseplanerApp } from '@bananasplit/core';

const app = new ReiseplanerApp();
await app.initialize();
```

## API Reference

### Endpunkte

- `/api/plans` - Reisen abrufen
- `/api/destinations` - Orte anzeigen
- `/api/users` - Benutzerdaten

### Authentifizierung

Alle API-Anfragen benötigen einen Bearer-Token im Header:

```
Authorization: Bearer YOUR_TOKEN
```

## Contributing

Wir freuen uns über Beiträge! Bitte lies unsere [Contributor Guidelines](CONTRIBUTING.md).

### Entwicklungsumgebung

```bash
npm run dev
npm run build
npm run lint
```

## License

Dieses Projekt ist unter der MIT-Lizenz veröffentlicht. Siehe [LICENSE](LICENSE) für Details.

---

<div align="center">
  <strong>🍌 Bananasplit – Reiseplaner</strong><br>
  <em>Built with ❤️ by the Phimance team</em>
</div>