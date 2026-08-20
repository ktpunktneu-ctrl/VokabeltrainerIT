# Vokabeltrainer — Projektübersicht

Stand: 2026-07-14

## Was ist das

Fünf eigenständige, baugleiche PWA-Vokabeltrainer-Apps von Klaus Tegtmeier:

| | VokabeltrainerIT | VokabeltrainerEN | VokabeltrainerFR | VokabeltrainerES | VokabeltrainerBusinessEN |
|---|---|---|---|---|---|
| Sprachpaar | Italienisch ↔ Deutsch | Englisch ↔ Deutsch | Französisch ↔ Deutsch | Spanisch ↔ Deutsch | Business English ↔ Deutsch |
| Verzeichnis | `C:\Users\klaus\VokabeltrainerIT` | `C:\Users\klaus\VokabeltrainerEN` | `C:\Users\klaus\VokabeltrainerFR` | `C:\Users\klaus\VokabeltrainerES` | `C:\Users\klaus\VokabeltrainerBusinessEN` |
| Port (lokal) | 5052 | 5053 | 5054 | 5055 | 5056 |
| Live-URL | https://ktpunktneu-ctrl.github.io/VokabeltrainerIT/ | https://ktpunktneu-ctrl.github.io/VokabeltrainerEN/ | — (Repo privat) | — (Repo privat) | — (Repo privat) |
| GitHub-Repo | ktpunktneu-ctrl/VokabeltrainerIT (öffentlich) | ktpunktneu-ctrl/VokabeltrainerEN (öffentlich) | ktpunktneu-ctrl/VokabeltrainerFR (privat) | ktpunktneu-ctrl/VokabeltrainerES (privat) | ktpunktneu-ctrl/VokabeltrainerBusinessEN (privat) |
| Vokabelanzahl | 548 (9 Kategorien) | 539 (9 Kategorien) | 539 (9 Kategorien) | 539 (9 Kategorien) | 394 (9 Kategorien, Business-Themen) |
| App-Version | v1.9 | v1.9 | v1.9 | v1.9 | v1.9 |
| OCR-Sprachcode | ita+deu | eng+deu | fra+deu | spa+deu | eng+deu |
| Design | Standard (Flaggenfarben-Akzent) | Standard | Standard | Standard | **Elegant/Premium** — Navy/Gold-Palette, Serifen-Header, für Manager-Zielgruppe |

## Technik

- **Backend:** Flask (`main.py`), liefert `index.html` (Cache-Control: no-store) und die Endpoints `/api/vokabeln` (GET/POST/PUT/DELETE), `/api/kategorien` und `/api/ocr` (Foto → Text via Tesseract-OCR, Sprachdaten in `tessdata/`). Persistenz serverseitig in `vokabeln.json` — kennt nur `id/kategorie/it/de` (Feldname `it` ist historisch aus dem IT-Projekt übernommen und wird aus Kompatibilitätsgründen in allen Apps unverändert als Schlüssel für das Fremdwort verwendet, unabhängig von der tatsächlichen Sprache). Läuft nur lokal, nicht Teil des Pages-Deployments.
- **Frontend:** Eine einzige `index.html` (HTML+CSS+JS inline). Daten primär in `localStorage` (Key `vokabeltrainer_{it,en,fr,es,biz}_vokabeln`), mit `SEED_VOKABELN` als Fallback/Erstbefüllung — dort sind auch die Konjugationsformen (`formen`) hinterlegt.
- **Konjugationsschema unterschiedlich je Sprachfamilie:** IT/FR/ES (romanische Sprachen) nutzen Personalform-Konjugation (io/tu/lui/noi/voi/loro bzw. je/tu/il/nous/vous/ils bzw. yo/tu/el/nosotros/vosotros/ellos), EN/BusinessEN nutzen `base/past/participle` (passend zur englischen Grammatik). `PERSON_LABEL`/`PERSONEN`-Konstanten in `index.html` steuern das generisch — Quiz-/Lernlisten-Code selbst ist sprachagnostisch.
- **PWA/Offline:** Service Worker (`static/sw.js` bzw. `docs/sw.js`) cached die App-Shell cache-first, funktioniert komplett offline unterwegs. **Wichtig:** Bei jeder inhaltlichen Änderung an `index.html` muss die `CACHE`-Versionskonstante in **beiden** `sw.js`-Kopien (`static/` und `docs/`) hochgezählt werden, sonst bleibt die alte Version für immer aktiv.
- **Pfade:** Alle Ressourcen-Pfade (`manifest.json`, Icons, `sw.js`-Registrierung) sind **relativ** (kein führendes `/`) — funktioniert dadurch sowohl lokal via Flask (an der Domain-Wurzel) als auch auf GitHub Pages (im jeweiligen Unterpfad).
- **`docs/`-Ordner** ist bei allen Apps 1:1-Kopie von Root (`index.html`, `sw.js` mit relativen Pfaden, eigenes `manifest.json`) für GitHub Pages Deployment. Bei jeder Änderung an Root-Dateien `docs/` manuell synchron halten — Pages baut automatisch bei jedem Push nach `main`. **GitHub Pages braucht ein öffentliches Repo** (kostenloser Plan) — FR/ES/BusinessEN sind aktuell privat und daher ohne Live-URL, auf Wunsch von Klaus (Stand 2026-07-14).
- **Sprachmodul:** Web Speech API (`speechSynthesis`), kostenlos/offline, 🔊-Button im Quiz und in der Lernliste.
- **Verwaltung:** Neue Vokabel (Live-Duplikat-Warnung), neue Kategorie (eigenes Modal), Vokabeln aus Foto per OCR (Kamera/Datei-Upload → Tesseract → editierbare Kandidatenliste → Bulk-Übernahme in eine Kategorie).
- **Trial-Modell:** Ohne Freischaltung ist Training/Quiz auf 10 Vokabeln je Kategorie begrenzt (Lernliste bleibt komplett sichtbar), Speichern neuer Vokabeln/Kategorien/OCR-Ergebnisse gesperrt (Lizenz-Modal öffnet sich sofort beim Öffnen des jeweiligen Formulars). Nach 14 Tagen ohne Freischaltung öffnet sich das Lizenz-Modal automatisch bei jedem Start.

## Änderungswarnung

Alle Apps sind komplett parallel gepflegt — **jede funktionale Code-Änderung muss identisch in allen Projekten nachgezogen werden.** Ausnahme: das visuelle Design von VokabeltrainerBusinessEN ist bewusst eigenständig (Premium-Optik für Manager-Zielgruppe) und muss bei reinen Farb-/Typografie-Änderungen NICHT an die anderen Apps angeglichen werden.

### Feature-Parität IT vs. Schwesterprojekte (Stand 2026-08-20, per Git-Abgleich geprüft — korrigiert)

**Wichtiger Befund:** In EN/FR/ES/BusinessEN ist aktuell **nicht `main` ausgecheckt, sondern der nie gemergte Branch `feature-srs-leitner`.** Nur bei IT ist Spaced Repetition bereits in `main`. Die erste Version dieser Tabelle (Stand vormittags) hatte nur die Dateien auf der Platte geprüft, nicht den Branch — dadurch war sie an zwei Stellen falsch: dem Splash-Redesign von BusinessEN (steht seit `bf46e21`/13.08. in `main`, nur mit eigenen CSS-Klassen für das Premium-Design statt `home-sphere`) und der Spaced-Repetition-Zeile (nur auf dem Feature-Branch, nicht in `main`).

| Änderung in IT | EN | FR | ES | BusinessEN |
|---|---|---|---|---|
| Install-Banner (In-App-Browser-Erkennung) | ✓ (main) | ✓ (main) | ✓ (main) | ✓ (main) |
| Lernbox-Start-Redesign (Splash) | ✓ (main) | ✓ (main) | ✓ (main) | ✓ (main, eigenes Premium-Design: BE-Monogramm, rechteckige Karten statt Kugeln) |
| Lernliste-Sortierfix bei DE→IT | ✓ (main) | ✓ (main) | ✓ (main) | ✓ (main) |
| Löschen/Korrigieren-Icons, Quiz-Reaktionen, Header-Icons | ✓ (main) | ✓ (main) | ✓ (main) | ✓ (main) |
| Spaced Repetition (Leitner-System) | ✓ (main) | ✗ nur auf Branch `feature-srs-leitner`, nicht gemergt | ✗ nur auf Branch `feature-srs-leitner`, nicht gemergt | ✗ nur auf Branch `feature-srs-leitner`, nicht gemergt (dort zusätzlich ein Selbsteinschätzungs-Modus für lange Umgangssprache-Einträge, den IT so noch nicht hat) |
| Lernbox-Zeilenversatz-Fix (2026-08-20) | ✗ | ✗ | ✗ | ✗ |

Praktische Folge: die Live-Version von EN auf GitHub Pages (öffentliches Repo, `main`-Branch) hat aktuell **kein** Spaced Repetition, obwohl der lokale Arbeitsstand es zeigt.

### Offene Nachzieharbeiten in Schwesterprojekte

- [ ] **`feature-srs-leitner` nach `main` mergen** in EN/FR/ES/BusinessEN, inkl. Bereinigung der CRLF/LF-Zeilenumbruch-Diffs (aktuell in allen Repos als "uncommitted changes" sichtbar, aber inhaltlich nur Zeilenumbrüche, keine echten Inhaltsänderungen — geprüft 2026-08-20). BusinessEN-Branch enthält zusätzlich einen Selbsteinschätzungs-Modus für lange Umgangssprache-Einträge (mehrere Wörter/kleine Sätze), der ursprünglich aus IT stammt und für Suche/Quiz-Bewertung relevant ist — beim Merge prüfen, ob das nach IT zurückübernommen werden soll.
- [ ] **Lernbox-Zeilenversatz-Fix** (`.ll-row{align-items:flex-start}` statt `center`, siehe Changelog 2026-08-20) — bisher **nur in VokabeltrainerIT** umgesetzt, danach in allen vier Schwester-Apps nachziehen (Root-`index.html` + `docs/index.html`, `CACHE`-Version in beiden `sw.js`-Kopien hochzählen).
- **Empfehlung zur Ausführung:** Diese Git-Merges sollten von Terminal-Claude-Code (oder Klaus direkt) gemacht werden, nicht über die Cloud-Session — die Cloud-Session kann zwar Dateien direkt schreiben, hat aber keinen vollwertigen Git-Zugriff auf dem Windows-Rechner (kann z.B. `.git/index.lock`-Dateien nicht löschen, was echte Commits/Merges unzuverlässig macht). Klaus-Entscheidung (2026-08-20): erst IT fertigstellen/testen, danach nachziehen.

## Changelog (Auszug, chronologisch)

- **2026-08-20:** Layout-Bug in der Lernbox behoben: Bei Einträgen mit langem/mehrzeilig umbrechendem Text (z.B. Synonym-Paare wie „cambio di casa, trascolo") wurde das kurze Gegenstück (z.B. „umzug") vertikal versetzt dargestellt, statt an der ersten Textzeile ausgerichtet zu sein. Ursache: `.ll-row{align-items:center}` zentrierte die Spalte vertikal zur gesamten (mehrzeiligen) Höhe. Fix: `align-items:flex-start` in `.ll-row` (`index.html` und `docs/index.html`), `CACHE`-Version in `static/sw.js`/`docs/sw.js` von `v46` auf `v47` erhöht, damit der Service Worker die neue Version ausliefert. **Nur in VokabeltrainerIT umgesetzt** — siehe „Offene Nachzieharbeiten" oben für die Schwesterprojekte.
- **2026-07-04 bis 07-12:** Sprachmodul/TTS, Feature-Gating, Trial-Modell, Add-/Kategorie-Modal, OCR-Feature — siehe Git-Historie von VokabeltrainerIT für Details (zuerst dort entwickelt).
- **2026-07-14:** EN auf v1.9 nachgezogen (Feature-Parität mit IT). VokabeltrainerFR und VokabeltrainerES neu angelegt (v1.9 von Anfang an), Vokabular übersetzt, `fra.traineddata`/`spa.traineddata` ergänzt, Repos privat gehalten (Klaus-Entscheidung). VokabeltrainerBusinessEN neu angelegt: 394 Business-Vokabeln (9 Kategorien: Grundlagen & Umgangsformen, Meetings, Verhandlungen, Finanzen & Kennzahlen, Präsentationen, E-Mail & Korrespondenz, Management & Führung, Projektmanagement, Verben), eigenständiges elegantes Design (Navy/Gold, Serifen-Header, Monogramm-Badge statt Flagge) für Manager-Zielgruppe, Repo privat.

## Vermarktung — Feature-Gating (seit 2026-07-06, Trial-Modell seit 2026-07-12)

Zielgruppe: Schüler & Interessierte (IT/EN/FR/ES), Berufstätige/Manager (BusinessEN). "Schmaler Kurs" (kleiner, günstiger Zugang statt Vollpreis-Produkt).

- **Freischaltung:** Code-Eingabefeld im Lizenz-Modal, prüft per Fetch gegen Gumroads License-Verification-API (`https://api.gumroad.com/v2/licenses/verify`).
- **Preis:** 9,95 € einmalig (IT/EN/FR/ES), 19,95 € (BusinessEN) — Kauf-Link im Modal.
- **Master-Code für Eigennutzung:** siehe Konstante `MASTER_CODE` in `index.html` (alle Apps) — schaltet sofort und dauerhaft frei, ganz ohne Gumroad-Prüfung/Internet. (Wert bewusst nicht in dieser Doku, IT/EN sind öffentliche Repos.)
- **Bestandsnutzer-Schutz:** `pruefeBestandsnutzer()` schaltet Nutzer, die vor dem Feature-Gating schon Daten hatten, automatisch dauerhaft frei.

**Noch offen / ACHTUNG — Klaus muss selbst tun:**
- **Gumroad-Produkte existieren noch nicht!** `GUMROAD_PERMALINK` in `index.html` ist je App nur ein Platzhalter (`vokabeltrainer-{it,en,fr,es,business-en}`), ebenso der Kauf-Link im Lizenz-Modal. Separate Gumroad-Produkte anlegen (Preis 9,95 €, License-Key-Generierung aktivieren), dann echte Permalinks eintragen (Stelle mit `// TODO Klaus:` markiert). Preis je Produkt: 9,95 € (IT/EN/FR/ES), 19,95 € (BusinessEN).

## Spaced Repetition (Leitner) — umgesetzt (seit 2026-08-20)

Nachrüstung eines Spaced-Repetition-Systems (Wiedervorlage nach Erinnerungsleistung, Leitner-artiges Prinzip mit Boxen 1-5, fällige Karten zuerst, Hinweis auf der Startseite) ist umgesetzt — Commit `5b7e71d` (2026-08-20). Laut Code-Abgleich vom selben Tag ist das Feature bereits identisch in allen fünf Apps (IT/EN/FR/ES/BusinessEN) vorhanden. Hintergrund: größte inhaltliche Lücke gegenüber Anki (siehe Marketingkonzept_Vokabeltrainer.docx), rechtfertigt für sich genommen keine Preiserhöhung, da Anki dieses Feature kostenlos anbietet.

## Schnellzugriff

- IT lokal starten: `start_vokabeltrainer.bat` (Port 5052)
- EN lokal starten: `start_vokabeltrainer_en.bat` (Port 5053)
- FR lokal starten: `start_vokabeltrainer_fr.bat` (Port 5054)
- ES lokal starten: `start_vokabeltrainer_es.bat` (Port 5055)
- BusinessEN lokal starten: `start_vokabeltrainer_business_en.bat` (Port 5056)
- IT live: https://ktpunktneu-ctrl.github.io/VokabeltrainerIT/
- EN live: https://ktpunktneu-ctrl.github.io/VokabeltrainerEN/
- FR/ES/BusinessEN: kein Live-Deployment (Repos privat)
