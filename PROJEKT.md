# Vokabeltrainer — Projektübersicht

Stand: 2026-07-05

## Was ist das

Zwei eigenständige, baugleiche PWA-Vokabeltrainer-Apps von Klaus Tegtmeier:

| | VokabeltrainerIT | VokabeltrainerEN |
|---|---|---|
| Sprachpaar | Italienisch ↔ Deutsch | Englisch ↔ Deutsch |
| Verzeichnis | `C:\Users\Klaus\VokabeltrainerIT` | `C:\Users\Klaus\VokabeltrainerEN` |
| Port (lokal) | 5052 | 5053 |
| Live-URL | https://ktpunktneu-ctrl.github.io/VokabeltrainerIT/ | https://ktpunktneu-ctrl.github.io/VokabeltrainerEN/ |
| GitHub-Repo | ktpunktneu-ctrl/VokabeltrainerIT (**öffentlich**) | ktpunktneu-ctrl/VokabeltrainerEN (**öffentlich**) |
| Vokabelanzahl | 539 (9 Kategorien × ~60) | 539 (9 Kategorien × ~60) |
| App-Version | v1.3 | v1.3 |

## Technik

- **Backend:** Flask (`main.py`), liefert `index.html` (Cache-Control: no-store) und die Endpoints `/api/vokabeln` (GET/POST/PUT/DELETE) und `/api/kategorien`. Persistenz serverseitig in `vokabeln.json` — kennt nur `id/kategorie/it/de`, **kein** Konjugationsfeld. Läuft nur lokal, nicht Teil des Pages-Deployments.
- **Frontend:** Eine einzige `index.html` (HTML+CSS+JS inline). Daten primär in `localStorage` (Key `vokabeltrainer_it_vokabeln` bzw. `_en_`), mit `SEED_VOKABELN` als Fallback/Erstbefüllung — dort sind auch die Konjugationsformen (`formen`) hinterlegt.
- **PWA/Offline:** Service Worker (`static/sw.js` bzw. `docs/sw.js`) cached die App-Shell cache-first, funktioniert komplett offline unterwegs. **Wichtig:** Bei jeder inhaltlichen Änderung an `index.html` muss die `CACHE`-Versionskonstante in **beiden** `sw.js`-Kopien (`static/` und `docs/`) hochgezählt werden, sonst bleibt die alte Version für immer aktiv.
- **Pfade:** Alle Ressourcen-Pfade (`manifest.json`, Icons, `sw.js`-Registrierung) sind **relativ** (kein führendes `/`) — funktioniert dadurch sowohl lokal via Flask (an der Domain-Wurzel) als auch auf GitHub Pages (im Unterpfad `/VokabeltrainerIT/` bzw. `/VokabeltrainerEN/`). Absolute Pfade hatten die Installation auf GitHub Pages kaputt gemacht (404 beim Manifest/SW) — am 2026-07-05 behoben.
- **Sync zwischen Geräten:** Button "Mit PC abgleichen" gleicht lokalen `localStorage`-Bestand mit dem Flask-Server im selben WLAN ab (`/api/vokabeln`). Funktioniert nur mit laufendem lokalem Server, nicht mit der Pages-Version (kein Backend dort).
- **`docs/`-Ordner** ist bei beiden Apps 1:1-Kopie von Root (`index.html`, `sw.js` mit relativen Pfaden, eigenes `manifest.json`) für GitHub Pages Deployment. Bei jeder Änderung an Root-Dateien `docs/` manuell synchron halten — Pages baut automatisch bei jedem Push nach `main`.
- **Sprachmodul:** Web Speech API (`speechSynthesis`), kostenlos/offline, 🔊-Button im Quiz und in der Lernliste.
- **Konjugationstraining:** eigener Modus "Konjugation" — fragt zufällige Personalform (io/tu/lui/... bzw. base/past/participle) ab, nur für Vokabeln mit `formen`-Feld.
- **Lernliste:** eigener Kategorie-Filter (isoliert bei Klick, wie im Quiz-Start) + Richtungsumschalter IT→DE / DE→IT, unabhängig vom Quiz-Modus, aber gleiche `S.selectedKat`-Auswahl geteilt mit dem Quiz-Start.

## Änderungswarnung

Beide Apps sind komplett parallel gepflegt — **jede Code-Änderung muss identisch in IT und EN nachgezogen werden** (bisher immer so gehandhabt).

## Changelog (Auszug, chronologisch)

- **2026-07-04:** Sprachmodul/TTS ergänzt, Anki-Export entfernt, Konjugationsformen-Sync-Bug behoben (`lsRepairFormen` + Merge-Fix), Kategorie-Filter im Quiz auf "isolieren statt togglen" umgestellt, Kategorie-Löschung inkl. enthaltener Vokabeln, sichtbare Versionsnummer im Header.
- **2026-07-05 vormittags:** Je 50 neue Vokabeln pro Kategorie ergänzt (→ 539 gesamt je Sprache), IT-Repo öffentlich gestellt + GitHub Pages eingerichtet (vorher nur EN live), Remote-Control fürs Handy eingerichtet.
- **2026-07-05 mittags:** Bug gefunden & behoben — absolute Pfade (`/manifest.json`, `/sw.js`, `/static/...`) verhinderten die PWA-Installation auf GitHub Pages (404), da die Apps dort im Unterpfad laufen. Auf relative Pfade umgestellt, betraf beide Apps gleichermaßen.
- **2026-07-05 nachmittags:** Lernliste-Kategoriefilter ebenfalls auf "isolieren statt togglen" umgestellt (war inkonsistent zum Quiz-Filter).

## Vermarktung — Feature-Gating implementiert (2026-07-06)

Zielgruppe: Schüler & Interessierte, "schmaler Kurs" (kleiner, günstiger Zugang statt Vollpreis-Produkt).

**Umgesetztes Modell:**
- **Feature-Sperre:** Konjugation/Verbformen-Training dauerhaft hinter Freischalt-Code gesperrt (🔒-Icon bei "Konjugation"/"Verbformen" in Start-Richtung und Lernliste-Tab). Klick ohne Freischaltung öffnet das Lizenz-Modal statt die Auswahl zu setzen. Grundwortschatz + normales Training bleiben frei.
- **14-Tage-Hinweis:** Installationsdatum wird beim allerersten Start in `localStorage` (`..._install_datum`) gespeichert. Nach 14 Tagen (`TESTPHASE_TAGE`) ohne Freischaltung öffnet sich bei jedem App-Start automatisch das Lizenz-Modal (nicht dauerhaft wegklickbar, kommt bei jedem Neustart wieder — aber keine harte Sperre der ganzen App).
- **Bestandsnutzer-Schutz:** `pruefeBestandsnutzer()` prüft beim allerersten Lauf dieses Codes, ob im Browser schon Vokabeldaten existieren (= App wurde schon vor dem Feature-Gating genutzt) → automatische, dauerhafte Freischaltung ohne Zutun. Betrifft die 3 bereits ausgelieferten EN-Testversionen. Neue Installationen ab jetzt starten normal mit 14-Tage-Test.
- **Freischaltung:** Code-Eingabefeld im Lizenz-Modal, prüft per Fetch gegen Gumroads kostenlose License-Verification-API (`https://api.gumroad.com/v2/licenses/verify`). Mechanismus getestet und funktionsfähig (Fetch/Response-Handling läuft sauber durch).
- **Preis:** 4,99 € einmalig, Kauf-Link im Modal.

**Noch offen / ACHTUNG — Klaus muss selbst tun:**
- **Gumroad-Produkt existiert noch nicht!** `GUMROAD_PERMALINK` in `index.html` (beide Apps) ist aktuell nur ein Platzhalter (`vokabeltrainer-it` / `vokabeltrainer-en`), ebenso der Kauf-Link `https://gumroad.com/l/...` im Lizenz-Modal. Klaus muss bei Gumroad ein Produkt pro App anlegen (Preis 4,99 €, License-Key-Generierung aktivieren), dann den echten Permalink in beide `index.html` eintragen (Stelle ist mit `// TODO Klaus:` markiert).
- Umfang der Sperre ist aktuell nur Konjugation/Verbformen — falls zusätzlich Kategorien gesperrt werden sollen, noch nicht umgesetzt.

## Schnellzugriff

- IT lokal starten: `start_vokabeltrainer.bat` (Port 5052)
- EN lokal starten: `start_vokabeltrainer_en.bat` (Port 5053)
- IT live: https://ktpunktneu-ctrl.github.io/VokabeltrainerIT/
- EN live: https://ktpunktneu-ctrl.github.io/VokabeltrainerEN/
