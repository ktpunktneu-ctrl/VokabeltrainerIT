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

### Feature-Parität IT vs. Schwesterprojekte (Stand 2026-08-21, per Git-Abgleich geprüft — Nachtauftrag erledigt)

**Update 2026-08-21 (nachts):** `feature-srs-leitner` in EN/FR/ES/BusinessEN nach `main` gemergt (jeweils sauberer Fast-Forward) und gepusht. BusinessEN hatte zusätzlich ein eigenständiges, uncommittetes Lernbox-Komfortpaket im Working Tree (Enter-Speichern, wortweise Suche, Kein-Treffer→Neuanlage u.a. — von der Cloud-Session direkt in die Dateien geschrieben, nicht committet) — vor dem Merge in einem eigenen Commit gesichert, dann mitgemergt. Alle vier Apps zusätzlich mit dem Lernbox-Zeilenversatz-Fix versehen. Details siehe Changelog unten. Die Behauptung der Vormittags-Tabelle "EN/FR/ES haben inhaltliche Diffs, nur CRLF" war zum Zeitpunkt der Prüfung nachts bereits überholt — EN/FR/ES hatten zu dem Zeitpunkt einen **sauberen** Working Tree (keine CRLF-Diffs mehr vorhanden), nur BusinessEN hatte echte (nicht nur CRLF-) uncommittete Änderungen. **Lehre: Git-Status-Behauptungen in diesem Dokument vor Ausführung immer frisch selbst prüfen, nicht aus einem älteren Tabellenstand übernehmen** — stimmte hier zum Glück, war aber durch zwischenzeitliche Cloud-Session-Schreibvorgänge in der Zwischenzeit nicht mehr aktuell.

| Änderung in IT | EN | FR | ES | BusinessEN |
|---|---|---|---|---|
| Install-Banner (In-App-Browser-Erkennung) | ✓ (main) | ✓ (main) | ✓ (main) | ✓ (main) |
| Lernbox-Start-Redesign (Splash) | ✓ (main) | ✓ (main) | ✓ (main) | ✓ (main, eigenes Premium-Design: BE-Monogramm, rechteckige Karten statt Kugeln) |
| Lernliste-Sortierfix bei DE→IT | ✓ (main) | ✓ (main) | ✓ (main) | ✓ (main) |
| Löschen/Korrigieren-Icons, Quiz-Reaktionen, Header-Icons | ✓ (main) | ✓ (main) | ✓ (main) | ✓ (main) |
| Lernbox-Komfortpaket (Enter-Speichern, wortweise Suche, Kein-Treffer→Neuanlage, FAB übernimmt Suchbegriff) | ✓ (main) | — (nicht Teil von EN/FR/ES' `feature-srs-leitner`, dort nie gebaut) | — | ✓ (main, 2026-08-21 gemergt) |
| Spaced Repetition (Leitner-System) | ✓ (main) | ✓ (main, 2026-08-21 gemergt) | ✓ (main, 2026-08-21 gemergt) | ✓ (main, 2026-08-21 gemergt, inkl. Selbsteinschätzungs-Modus für lange Umgangssprache-Einträge — siehe offener Punkt unten) |
| Lernbox-Zeilenversatz-Fix (2026-08-20) | ✓ (main) | ✓ (main, 2026-08-21) | ✓ (main, 2026-08-21) | ✓ (main, 2026-08-21) |
| DE→IT-Feldreihenfolge-Fix bei Neuanlage aus Suche | ✓ (main) | — | — | — (BusinessEN hat den Suche-Neuanlage-Flow zwar, aber keine Richtungsumschaltung wie IT — Fix dort nicht anwendbar) |

**Bewusste Lücke, nicht vergessen:** EN/FR/ES haben das Lernbox-Komfortpaket (Enter-Speichern, wortweise Suche etc.) nach wie vor **nicht** — das war schon vor heute Nacht offen (siehe oben im Dokument: "EN/FR/ES/LA noch offen") und war nicht Teil des heutigen Nachtauftrags (der Auftrag bezog sich nur auf `feature-srs-leitner`-Merge + Zeilenversatz-Fix). Separater künftiger Rollout nötig.

### Offene Punkte

- [ ] **Selbsteinschätzungs-Modus zurück nach IT übernehmen?** BusinessEN hat seit dem Merge (Commit `8c3d0de`) einen Quiz-Selbsteinschätzungs-Modus für lange Einträge (>3 Wörter/kleine Sätze: Antwort wird angezeigt, "Kenne ich"/"Nochmal üben" statt Abtippen). Laut Auftrag stammt das Konzept ursprünglich aus IT, ist dort aber (Stand 2026-08-21) **nicht vorhanden** — IT hat aktuell kein Pendant für lange Umgangssprache-Einträge. Nicht selbst entschieden, siehe Auftrag — **Klaus muss klären**, ob das nach IT zurückportiert werden soll.
- [ ] **BusinessEN-Logo:** Neue Bildvorlage `static/logo-neu-BE-2026-08-20.png` liegt vor. Icon-Kandidaten (192/512/ico, je einmal transparent und einmal mit Original-Hintergrund) wurden generiert unter `static/logo-vorschau/{transparent,opak}/` — **noch nicht ins Live-System integriert**, da zwei Entscheidungen offen sind: (1) transparenter Hintergrund oder Fläche erhalten, (2) Splash-Startseite auf das neue Bild-Logo umstellen oder beim bestehenden Text-Monogramm bleiben. Nach Klaus' Entscheidung: gewählte Variante nach `static/`+`docs/static/` kopieren, Splash ggf. anpassen, `CACHE`-Version erneut hochzählen.
- [ ] **Lernbox-Komfortpaket auf EN/FR/ES nachziehen** (siehe "Bewusste Lücke" oben) — unabhängig vom heutigen Nachtauftrag, weiterhin offen.

## Changelog (Auszug, chronologisch)

- **2026-08-21 (nachts, Terminal-Claude-Code):** Nachtauftrag "Schwester-Apps auf IT-Stand bringen" ausgeführt. Vor jeder Aktion Ist-Zustand frisch verifiziert (nicht nur den Auftragstext vertraut) — dabei stale `.git/index.lock`-Dateien in IT/EN/BusinessEN gefunden und entfernt (kein aktiver Git-Prozess, sicher entfernbar), sowie in BusinessEN echtes uncommittetes Lernbox-Komfortpaket entdeckt, das der Auftragstext nicht erwähnte (zuerst gesichert/committet, dann mitgemergt). Pro Repo: `feature-srs-leitner`→`main` gemergt (alle vier sauberer Fast-Forward), `.ll-row`-Fix + `CACHE`-Version-Bump angewendet, per `node --check` + Live-Test (lokaler Server, `javascript_tool`: SRS-Funktionen vorhanden, CSS korrekt, Suche/Neuanlage-Flow funktional, keine JS-Fehler) verifiziert, dann committet und gepusht. FR: Live-Test übersprungen (Port 5054 kollidiert mit dem laufenden Ellis-Fischmobil-Tool), stattdessen nur Datei+Syntax-Check — identischer Fix, an EN bereits live bestätigt. Icon-Kandidaten fürs neue BusinessEN-Logo generiert (transparent+opak), Integration bewusst zurückgestellt (zwei offene Design-Entscheidungen, siehe "Offene Punkte"). IT selbst bekam denselben Zeilenversatz-Fix zusätzlich in den zweiten lokalen Ordner (`VokabeltrainerIT_Entwurf_LernboxStart`) gepullt, da der dortige Dev-Server (Port 5052) sonst weiter die alte Version ausgeliefert hätte — beim ersten Live-Check bemerkt (Fix zeigte sich zunächst nicht, weil der falsche Ordner lief).
- **2026-08-20:** Layout-Bug in der Lernbox behoben: Bei Einträgen mit langem/mehrzeilig umbrechendem Text (z.B. Synonym-Paare wie „cambio di casa, trascolo") wurde das kurze Gegenstück (z.B. „umzug") vertikal versetzt dargestellt, statt an der ersten Textzeile ausgerichtet zu sein. Ursache: `.ll-row{align-items:center}` zentrierte die Spalte vertikal zur gesamten (mehrzeiligen) Höhe. Fix: `align-items:flex-start` in `.ll-row` (`index.html` und `docs/index.html`), `CACHE`-Version in `static/sw.js`/`docs/sw.js` von `v46` auf `v47` erhöht, damit der Service Worker die neue Version ausliefert.
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

## OCR clientseitig auf Tesseract.js umgestellt (2026-09-06)

**Problem:** Das OCR-Feature ("Foto -> Vokabelpaare") rief bisher `fetch('/api/ocr', ...)` auf, ein Flask-Endpoint, der nur laeuft, wenn Klaus' lokaler Server aktiv ist. Auf der live gehosteten GitHub-Pages-Version (rein statisch) lieferte das 404 -- OCR war fuer jeden echten Kunden kaputt.

**Loesung:** OCR laeuft jetzt komplett im Browser via **Tesseract.js v5.1.1** (WASM-Port derselben Tesseract-Engine, gleiche Erkennungsqualitaet wie vorher per pytesseract). Kein Backend mehr noetig, funktioniert auch offline nach der Erstinstallation.

**Umgesetzt:**
- Neue Dateien in `static/` und `docs/static/`: `tesseract.min.js`, `worker.min.js`, `tesseract-core-lstm.wasm.js` + `.wasm` (nur die LSTM-Core-Variante, passend zu den bereits vorhandenen `tessdata_fast`-Sprachdaten), `tessdata/deu.traineddata` + `tessdata/ita.traineddata` (wiederverwendet aus dem bereits vorhandenen `tessdata/`-Ordner, kein Neu-Download noetig).
- `ocrBildGewaehlt()` ruft jetzt `Tesseract.recognize(file, 'ita+deu', {...})` statt `fetch('/api/ocr')`. `corePath`/`workerPath`/`langPath` werden zur Laufzeit als **absolute URLs** ueber `new URL(p, document.baseURI).href` aufgeloest -- wichtig, weil ein Web Worker relative Pfade sonst relativ zu seiner eigenen Script-URL aufloest (nicht relativ zur Seite), was auf GitHub Pages' Unterpfaden sonst ins Leere gelaufen waere.
- `sw.js` (`static/` + `docs/`, Version -> `vokabelit-v48`): die 6 neuen Assets in `ASSETS` aufgenommen, damit sie beim ersten Besuch vorgecacht werden (echte Offline-Faehigkeit ab dem ersten App-Start, nicht erst nach dem ersten Online-OCR-Versuch).
- `main.py`/`/api/ocr` bewusst nicht angefasst -- bleibt als lokaler Fallback/Dev-Tool bestehen, wird vom Frontend aber nicht mehr aufgerufen.
Zusaetzlich behoben: `docs/sw.js` nutzte bisher absolute Pfade (`/...`) statt relativer (`./...`) wie alle anderen 5 Apps -- auf GitHub Pages (Unterpfad `/VokabeltrainerIT/`) fuehrte das dazu, dass `caches.addAll()` beim Install fehlschlug (404 auf `/`, `/static/...`), wodurch vermutlich **gar keine** Offline-Vorcachung griff, nicht nur OCR. Jetzt wie die anderen Apps auf relative Pfade umgestellt.

**Getestet:** Kompletter OCR-Durchlauf (corePath/langPath/gzip:false exakt wie im Frontend-Code) in Node.js mit den echten `tessdata_fast`-Dateien nachgebaut und verifiziert -- Text wird korrekt erkannt. Alle geaenderten `sw.js`/inline `<script>`-Bloecke mit `node --check` auf Syntaxfehler geprueft. Alle neuen Asset-Pfade per HTTP-Server-Test (docs/-Ordner wie GitHub Pages ausgeliefert) auf 200 OK verifiziert. **Nicht moeglich in dieser Session:** ein echter Klick-Test im Browser (Chrome-Erweiterung war nicht verbunden) -- vor dem naechsten Marketing-Push einmal auf einem echten Handy/Browser gegentesten.
