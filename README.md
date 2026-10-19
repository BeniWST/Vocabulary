# Vokabeltrainer – Einrichtung

Web-App (PWA) fürs iPhone: Englisch, Französisch, Latein · Lernkartei (Leitner, 5 Fächer) · mehrere Kinder · Eltern-Bereich mit PIN · Sync über Supabase.

Am einfachsten richtest du alles am **PC/Mac** ein. Das Installieren aufs Handy passiert danach in Safari.

---

## Schritt 1 – GitHub: App online stellen (ca. 5 Min.)

1. Auf **github.com** mit deinem **privaten** Account anmelden.
2. Oben rechts **+ → New repository**.
   - **Owner:** dein privater Benutzername (nicht die Firmen-Organisation!)
   - **Name:** `vokabeltrainer`
   - **Public** (für kostenloses GitHub Pages nötig – es liegen nur Code-Dateien drin, keine Vokabeln, keine Namen)
   - **Create repository**
3. Auf der leeren Repo-Seite: **„uploading an existing file“** anklicken und alle Dateien aus dem ZIP hineinziehen (`index.html`, `config.js`, `sw.js`, `manifest.json`, die drei `.png`, diese `README.md`, `supabase-setup.sql`) → **Commit changes**.
4. **Settings → Pages** → Source: **Deploy from a branch** → Branch **main**, Ordner **/ (root)** → **Save**.
5. Nach 1–2 Minuten ist die App erreichbar unter
   `https://DEIN-BENUTZERNAME.github.io/vokabeltrainer/`

> Jetzt läuft sie im **lokalen Testmodus**: Du kannst alles ausprobieren, die Daten bleiben aber nur auf dem jeweiligen Gerät.

---

## Schritt 2 – Supabase: Datenbank einrichten (ca. 10 Min.)

1. Auf **supabase.com** → **Start your project** → mit privater E-Mail oder privatem GitHub registrieren.
2. **New project**
   - Name: `vokabeltrainer`
   - Database Password: beliebig (wird nicht in der App gebraucht, aber notieren)
   - Region: **Central EU (Frankfurt)**
   - Plan: **Free**
3. Links **SQL Editor → New query** → Inhalt von `supabase-setup.sql` einfügen → **Run**. Es sollte „Success“ erscheinen.
4. **Familien-Konto anlegen:** **Authentication → Users → Add user → Create new user**
   - E-Mail + Passwort deiner Wahl (dieses Login benutzt ihr auf allen Geräten)
   - Haken bei **Auto Confirm User** setzen
5. **Registrierung für Fremde abschalten (wichtig!):** **Authentication → Sign In / Providers** → **„Allow new users to sign up“ ausschalten** → Speichern.
6. **Schlüssel holen:** **Project Settings → API Keys** (bzw. **Data API**)
   - **Project URL** kopieren (z. B. `https://abcdefgh.supabase.co`)
   - **Publishable key** (`sb_publishable_…`) bzw. **anon public** Key kopieren

## Schritt 3 – App mit Supabase verbinden

1. Auf GitHub im Repo auf **config.js** klicken → **Stift-Symbol (Edit)**.
2. Die beiden Werte eintragen:
   ```js
   supabaseUrl: "https://abcdefgh.supabase.co",
   supabaseKey: "sb_publishable_xxxxxxxxxxxx",
   ```
3. **Commit changes**. Nach ca. 1 Minute ist die neue Version online.

> Der Publishable/anon Key darf öffentlich sein. Ohne Login kommt niemand an die Daten, und neue Konten können nicht angelegt werden.

---

## Schritt 4 – Auf dem iPhone installieren

Auf **jedem** Gerät (Kind und du):

1. **Safari** öffnen (wichtig: nicht Chrome) → die GitHub-Pages-Adresse aufrufen.
2. Unten auf **Teilen** (Quadrat mit Pfeil) → **Zum Home-Bildschirm** → **Hinzufügen**.
3. App über das neue Icon öffnen → mit dem **Familien-Konto** anmelden.
4. **Wer lernt hier?**
   - Handy des Kindes: Profil anlegen bzw. auswählen
   - Dein Handy: **„Nur Eltern-Gerät“**
5. Unten auf **🔒 Eltern** → **PIN festlegen**. Die PIN gilt pro Gerät; auf dem Kinder-Handy legst du sie selbst fest, damit nur du Vokabeln ändern kannst.

---

## Vokabeln hinzufügen

**Eltern → Import** → Kind wählen → Sprache → Unit → Liste einfügen → **Hinzufügen**.

Format: eine Vokabel pro Zeile, Fremdsprache links, Deutsch rechts:

```
apple ; Apfel
to look after ; sich kümmern um
la maison ; das Haus
puella ; Mädchen ; -ae f.
```

- Trenner: `;`, Tab, `=` oder ` – `
- Optionale 3. Spalte = Notiz (Grammatik, Beispielsatz …)
- Mehrere richtige Bedeutungen mit Komma: `to leave ; verlassen, abfahren`
- Liste aus dem Schulbuch: Seite fotografieren → im Foto Text lange drücken (Live Text) → kopieren → einfügen. Oder Foto an Claude schicken und die fertige Liste einfügen.
- Eine Unit lässt sich unter **Eltern → Vokabeln** per **📤 Kopieren** an ein Geschwisterkind weitergeben.

---

## So lernt die App

- Jede Vokabel wird **in beide Richtungen** gelernt; jede Richtung hat ein eigenes Fach.
- Richtig → ein Fach weiter (Wiederholung nach 1, 2, 4, 8, 16 Tagen). Falsch → zurück in Fach 1, und die Karte kommt in derselben Runde nochmal.
- Pro Runde max. 20 Karten, davon höchstens 8 neue.
- **Test-Modus** (vor Klassenarbeiten): fragt alle Vokabeln einer Unit ab, ohne die Lernkartei zu verändern.
- Beim Tippen werden fehlende Akzente und Artikel toleriert (mit Hinweis), ein falscher Artikel (le/la) zählt als falsch. Über **„Ich hatte recht“** kann man eine Wertung korrigieren.
- Punkte (XP), Level, Tages-Serie und Tagesziel motivieren.

---

## Gut zu wissen

- **Offline:** Die App funktioniert ohne Internet. Der Abgleich passiert automatisch, sobald wieder Netz da ist.
- **Supabase Free:** Projekte ohne Aktivität werden nach ca. 7 Tagen pausiert (z. B. in den Ferien). Dann im Supabase-Dashboard auf **Restore** klicken; bis dahin läuft die App offline weiter.
- **Updates:** Datei auf GitHub ändern → kommt beim nächsten Öffnen automatisch an.
- **PIN vergessen:** App-Icon vom Home-Bildschirm löschen, neu über Safari hinzufügen und anmelden. Vokabeln und Lernstand liegen in Supabase und kommen automatisch zurück.
- **Sicherung:** Eltern → Einstellungen → Exportieren erzeugt eine JSON-Datei mit allen Profilen.
