# Claude Bridge

Zwei Oberflächen: eine Claude-ähnliche Chat-Webseite und ein separates Admin-Dashboard. Nachrichten werden **manuell** an Claude weitergegeben: Die Webseite legt eine Übergabe an, das Handy zeigt sie an, du kopierst sie in Claude und fügst die Antwort anschließend in Claude Bridge ein.

## Wichtig: Was dieses Projekt macht – und was nicht
- Es automatisiert **nicht** die Claude-Webseite und umgeht keine Claude-Sicherheits- oder Nutzungslimits.
- Es gibt keine offizielle Möglichkeit, beliebige bestehende Claude-Web-Chats direkt aus der Website auszulesen. Bestehende Chats können über einen Claude-Datenexport als JSON importiert werden (je nach Exportformat ggf. Anpassung nötig).
- Browser-Benachrichtigungen funktionieren zuverlässig, wenn die Handy-Web-App geöffnet ist. Echte Hintergrund-Push-Benachrichtigungen benötigen zusätzlich einen Push-Dienst und Server-seitige VAPID-Schlüssel; diese erste Version nutzt Supabase Realtime und lokale Systembenachrichtigungen im geöffneten PWA-Fenster.
- ChatGPT Bridge speichert Inhalte in deinem eigenen Supabase-Projekt. Nutze ein privates Repository, wenn du die Projektdateien nicht öffentlich teilen möchtest.

## 1. Supabase einrichten
1. Erstelle ein Projekt auf https://supabase.com.
2. Öffne **SQL Editor** und führe den Inhalt von `supabase/schema.sql` aus.
3. Unter **Project Settings → API** kopiere Project URL und anon/public key.
4. Kopiere `config.example.js` zu `config.js` und trage URL und anon key ein. `config.js` wird nicht versioniert; niemals den service_role-Key im Browser verwenden.
5. Aktiviere Email OTP in **Authentication → Providers → Email**.

## 2. GitHub Pages
1. Repository Settings → Pages.
2. Source: **Deploy from a branch**, Branch `main`, Folder `/ (root)`.
3. Lege `config.js` lokal an und veröffentliche sie nicht in einem öffentlichen Repository. Für eine öffentliche Demo ohne Konfiguration zeigt die Seite eine Einrichtungsanleitung. Für produktiven Betrieb empfiehlt sich ein privates Repository oder ein Hosting mit Build-Environment-Secrets.
4. Öffne die GitHub-Pages-URL und melde dich mit deiner E-Mail an. Bestätige den Login-Link/Code.

## 3. Handy koppeln
1. Öffne dieselbe Website am Handy und melde dich mit demselben Konto an.
2. Browser-Menü → **Zum Startbildschirm hinzufügen**.
3. Öffne den Handy-Modus über `?mode=phone`, erlaube Benachrichtigungen und lasse die Seite geöffnet, während du Übergaben erwartest.
4. Wenn eine Übergabe erscheint, kopiere die Nachricht und öffne Claude. Sende sie dort manuell.
5. Kopiere Claudes Antwort zurück in das Antwortfeld auf dem Handy und tippe **Antwort zurücksenden**.

## 4. Claude-Chats importieren
Nutze in der Chat-Seitenleiste **Chats importieren** und wähle eine JSON-Datei aus deinem Claude-Datenexport. Prüfe die importierten Inhalte und markiere nur die gewünschten Chats zur Synchronisierung. Der Importer versucht gängige JSON-Formate zu erkennen; Exporte können sich unterscheiden.

## 5. Seiten
- `index.html`: Chat-Oberfläche und Handy-Übergabeposten.
- `admin.html`: Statistiken, Geräte und Übergaben.
- `supabase/schema.sql`: Tabellen, RLS und Realtime-Konfiguration.

## Sicherheit
Die Anwendung verwendet Supabase Auth und Row Level Security. Teile niemals deinen Supabase service_role-Key. Der anon-Key ist für Browser-Anwendungen vorgesehen und wird durch RLS abgesichert. Lege keine Passwörter oder Claude-Session-Cookies in dieser Anwendung ab.
