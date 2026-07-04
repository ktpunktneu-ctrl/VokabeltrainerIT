# Vokabeltrainer — Projektübersicht

Stand: 2026-07-04

## Was ist das

Zwei eigenständige, baugleiche PWA-Vokabeltrainer-Apps von Klaus Tegtmeier:

| | VokabeltrainerIT | VokabeltrainerEN |
|---|---|---|
| Sprachpaar | Italienisch ↔ Deutsch | Englisch ↔ Deutsch |
| Verzeichnis | `C:\Users\Klaus\VokabeltrainerIT` | `C:\Users\Klaus\VokabeltrainerEN` |
| Port (lokal) | 5052 | 5053 |
| Live-URL | keine (nur lokal) | https://ktpunktneu-ctrl.github.io/VokabeltrainerEN/ |
| GitHub-Repo | ktpunktneu-ctrl/VokabeltrainerIT (privat) | ktpunktneu-ctrl/VokabeltrainerEN (**öffentlich**) |
| Vokabelanzahl | 81 (nach Löschtest "Zeit" wieder auf 89, siehe unten) | ähnlich, eigener Datensatz |

## Technik

- **Backend:** Flask (`main.py`), liefert `index.html` (Cache-Control: no-store) und die Endpoints `/api/vokabeln` (GET/POST/PUT/DELETE) und `/api/kategorien`. Persistenz serverseitig in `vokabeln.json` — kennt nur `id/kategorie/it/de`, **kein** Konjugationsfeld.
- **Frontend:** Eine einzige `index.html` (HTML+CSS+JS inline). Daten primär in `localStorage` (Key `vokabeltrainer_it_vokabeln` bzw. `_en_`), mit `SEED_VOKABELN` als Fallback/Erstbefüllung — dort sind auch die Konjugationsformen (`formen`) hinterlegt.
- **PWA/Offline:** Service Worker (`static/sw.js` bzw. `docs/sw.js` bei EN) cached die App-Shell cache-first, funktioniert komplett offline unterwegs. **Wichtig:** Bei jeder inhaltlichen Änderung an `index.html` muss die `CACHE`-Versionskonstante in `sw.js` hochgezählt werden, sonst bleibt die alte Version für immer aktiv (Cache-first ignoriert HTTP-Cache-Header).
- **Sync zwischen Geräten:** Button "Mit PC abgleichen" gleicht lokalen `localStorage`-Bestand mit dem Flask-Server im selben WLAN ab (`/api/vokabeln`).
- **EN-Besonderheit:** `docs/`-Ordner ist 1:1-Kopie von Root (`index.html`, `sw.js`) für GitHub Pages Deployment. Bei jeder Änderung an Root-Dateien muss `docs/` manuell synchron gehalten werden — Pages baut dann automatisch aus `docs/` bei jedem Push nach `main` (kein extra Build-Schritt, ca. 30–60 Sek.).
- **Sprachmodul:** Web Speech API (`speechSynthesis`), kostenlos/offline, 🔊-Button im Quiz und in der Lernliste.
- **Konjugationstraining:** eigener Modus "Konjugation" — fragt zufällige Personalform (io/tu/lui/... bzw. base/past/participle) ab, nur für Vokabeln mit `formen`-Feld.

## Änderungen vom 2026-07-04 (heute)

1. **Bug: Konjugationsformen verschwanden nach PC-Sync** — `syncMitPC()` überschrieb den kompletten lokalen Bestand mit der Serverantwort, die nie `formen` enthält (Server kennt das Feld nicht). Fix: Merge behält vorhandene `formen` anhand des Schlüssels (Kategorie|IT|DE). Zusätzlich `lsRepairFormen()` beim Laden — repariert auch bereits beschädigte Altbestände automatisch aus dem eingebetteten `SEED_VOKABELN`.
2. **Bug: Kategorie-Filter funktionierte nicht wie erwartet** — Default-Zustand war "alle Kategorien aktiv"; ein Klick auf eine einzelne Kategorie hat sie nur *abgewählt* (alle anderen blieben aktiv) statt sie zu isolieren. Fix: erster Klick (wenn gerade alle aktiv) wählt jetzt **nur** diese eine Kategorie; erneuter Klick auf die einzige aktive Kategorie schaltet zurück auf "alle". Mehrfachauswahl bleibt weiterhin möglich (aus dem isolierten Zustand weitere Kategorie dazu klicken).
3. **Anki-Export-Feature entfernt** (Button + `exportFuerAnki()`-Funktion) — nicht mehr benötigt.
4. **Kategorie-Löschung erweitert** — Verwaltung erlaubt jetzt auch das Löschen nicht-leerer Kategorien (vorher blockiert), mit explizitem Warnhinweis inkl. Anzahl betroffener Vokabeln vor dem Löschen.
5. **Sichtbare Versionsnummer** — `v1.1` steht jetzt dezent im Header neben dem Titel (Konstante `APP_VERSION` in `index.html`, bei künftigen Änderungen hochzählen).
6. **Service-Worker-Cache-Version hochgezählt** — IT: `vokabelit-v14`, EN: `vokabelen-v5` — nötig, damit Nutzer die obigen Änderungen überhaupt zu sehen bekommen.

Alle Änderungen wurden in beiden Apps identisch nachgezogen und commited/gepusht.

## Vermarktungsidee (neu, unentschieden)

Klaus erwägt, die App(s) als **schmalen, günstigen Kurs für Schüler & Interessierte** zu vermarkten (kein Vollpreis-Produkt, eher kleiner Zugang).

**Offene Punkte, bevor das umsetzbar ist:**

- **Kein Zugriffsschutz vorhanden.** Aktuell kann jeder mit dem Link die App dauerhaft kostenlos nutzen (auch offline als installierte PWA). Das Repo privat zu stellen löst das *nicht* — solange die Seite über GitHub Pages läuft, ist sie öffentlich erreichbar, unabhängig von der Repo-Sichtbarkeit.
- **GitHub Pages + privates Repo geht nicht im Free-Plan.** Private Repos + Pages braucht GitHub Pro (bezahlt) oder eine andere Hosting-Lösung (Netlify/Vercel/Cloudflare Pages unterstützen oft privates Repo + öffentliche Site im kostenlosen Tier).
- **Empfehlung (Stand jetzt):** Erst mit ein paar Testnutzern kostenlos validieren, ob das Format ankommt. Erst bei echtem Verkaufsvorhaben eine einfache Zugriffssperre einbauen — z. B. simple Zugangscode-Abfrage vor der App, oder Verkauf über Gumroad/Lemonsqueezy mit Code-Freischaltung. Kein volles Login-System nötig für einen kleinen Kurs.
- **Noch zu klären:** Soll die IT-Version dann auch öffentlich deployed werden (aktuell nur lokal)? Preismodell? Umfang des "Kurses" (nur App-Zugang, oder zusätzliches Lernmaterial/Videos)?

## Schnellzugriff

- IT lokal starten: `start_vokabeltrainer.bat` (Port 5052)
- EN lokal starten: `start_vokabeltrainer_en.bat` (Port 5053)
- EN live: https://ktpunktneu-ctrl.github.io/VokabeltrainerEN/
