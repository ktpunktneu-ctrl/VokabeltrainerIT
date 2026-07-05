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

## Vermarktung — Entschieden: Feature-Gating + 14-Tage-Hinweis

Zielgruppe: Schüler & Interessierte, "schmaler Kurs" (kleiner, günstiger Zugang statt Vollpreis-Produkt).

**Modell (Stand 2026-07-05, entschieden, noch nicht umgesetzt):**
- **Feature-Sperre:** Konjugationstraining (und ggf. ein Teil der Kategorien) dauerhaft hinter einem Freischalt-Code gesperrt. Grundwortschatz + normales Training bleiben frei nutzbar.
- **14-Tage-Hinweis:** Installationsdatum beim ersten Start in `localStorage` merken. Nach 14 Tagen ohne Freischaltung bei **jedem** App-Start ein Hinweis-Modal ("Testphase vorbei — jetzt freischalten") — nicht blockierend, aber nicht dauerhaft wegklickbar (kommt bei jedem Neustart wieder). Kein hartes Sperren der App insgesamt.
- **Freischaltung:** Verkauf über **Gumroad** (kostenlose License-Verification-API — Käufer bekommt automatisch individuellen Lizenzschlüssel per Mail, App prüft Code per Fetch gegen Gumroads API, kein eigener Server nötig). Robuster als ein einzelner geteilter Code.
- **Preis:** Einmalzahlung (kein Abo, passt besser zu "schmal") — Empfehlung **4,99 €** einmalig, Impulskauf-Preisregion.

**Noch offen:**
- Konkrete Umsetzung (Modal, Gumroad-Anbindung, Code-Eingabefeld) — noch nicht gebaut, nur konzeptionell entschieden.
- Umfang der Sperre genau festlegen (nur Konjugation, oder auch bestimmte Kategorien?).
- Ob/wie das Modell für IT und EN identisch oder unterschiedlich bepreist wird.

## Schnellzugriff

- IT lokal starten: `start_vokabeltrainer.bat` (Port 5052)
- EN lokal starten: `start_vokabeltrainer_en.bat` (Port 5053)
- IT live: https://ktpunktneu-ctrl.github.io/VokabeltrainerIT/
- EN live: https://ktpunktneu-ctrl.github.io/VokabeltrainerEN/
