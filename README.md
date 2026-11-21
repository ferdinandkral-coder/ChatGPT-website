# Claude Bridge

Claude-ähnliche Chat-Oberfläche plus getrenntes Admin-Dashboard. Nachrichten werden bewusst **manuell** weitergegeben: Du bestätigst am Handy, kopierst den Prompt in Claude und fügst Claudes Antwort wieder in Claude Bridge ein.

## Funktionen
- Chats auf der Webseite erstellen, speichern und erneut öffnen.
- Claude-Exportdatei im JSON-Format importieren (Exportformate können variieren).
- Importierte Chats in der Admin-Seite einzeln für die Synchronisierung markieren.
- Übergaben auf einem zweiten Gerät über Supabase Realtime sehen.
- Prompt kopieren, in Claude einfügen und Antwort in den ursprünglichen Chat zurückschreiben.
- Dashboard mit Chat-, Nachrichten- und Übergabestatistiken.
- Handy-Ansicht als installierbare PWA.

## Grenzen der manuellen Weiterleitung
- Die App kann keine Nachrichten automatisch in die Claude-Webseite eintippen oder Antworten von dort auslesen. Das passiert absichtlich manuell durch dich.
- Bestehende Claude-Webchats werden nicht live aus Claude abgerufen. Du musst zuerst deinen Claude-Datenexport herunterladen und die JSON-Datei importieren. Wenn sich das Exportformat ändert, muss der Importer angepasst werden.
- Diese Version zeigt Benachrichtigungen im geöffneten Browser/PWA-Fenster. Zuverlässige Push-Nachrichten bei vollständig geschlossener App benötigen einen zusätzlichen Push-Server (VAPID/Web Push), der noch nicht eingerichtet ist.
- Ein einfacher Browser-Dialog/Clipboard-Zugriff kann je nach Handy-Browser eine Berechtigungsabfrage auslösen.

## 1. Supabase vorbereiten
1. Erstelle ein Projekt unter https://supabase.com.
2. Öffne **SQL Editor** und führe `supabase/schema.sql` vollständig aus.
3. Unter **Project Settings → API** kopiere die **Project URL** und den **anon/public key**.
4. Öffne `config.js` und trage diese beiden Werte ein.
5. Aktiviere Email OTP unter **Authentication → Providers → Email**.
6. Ergänze unter **Authentication → URL Configuration** deine GitHub-Pages-URL als Site URL und Redirect URL.

**Sicherheit:** Der anon/public-Key ist für Browser-Apps vorgesehen. Die Tabellen sind mit Row Level Security geschützt. Niemals den `service_role`-Key oder ein Datenbankpasswort in `config.js` eintragen. Für ein öffentliches Repository ist der anon-Key sichtbar; das ist normal, solange RLS korrekt aktiviert bleibt.

## 2. GitHub Pages aktivieren
1. Öffne dieses Repository → **Settings → Pages**.
2. Bei **Build and deployment** die Quelle **Deploy from a branch** auswählen.
3. Branch `main`, Ordner `/(root)`, dann **Save**.
4. Warte auf den GitHub-Pages-Build. Die URL wird auf der Pages-Seite angezeigt.
5. Öffne die URL. Chat unter `/`, Verwaltung unter `/admin.html`, Handy-Ansicht unter `/?mode=phone`.

GitHub Pages ist statisches Hosting. Die Datenbank und Anmeldung laufen über dein eigenes Supabase-Projekt.

## 3. Handy koppeln
1. Öffne die GitHub-Pages-URL am Android-Handy.
2. Melde dich mit derselben E-Mail-Adresse an wie am Computer.
3. Öffne `/?mode=phone` und erlaube Browser-Benachrichtigungen.
4. Im Browser-Menü **Zum Startbildschirm hinzufügen** wählen.
5. Lass die PWA geöffnet, solange du zeitnahe Benachrichtigungen erwartest.
6. Bei einer Übergabe auf **Nachricht kopieren & bestätigen** tippen, Claude öffnen und die Nachricht manuell senden.
7. Claudes Antwort kopieren, in das Antwortfeld auf dem Handy einfügen und **Antwort zurücksenden** drücken.

## 4. Claude-Chats importieren
1. Lade in Claude deinen Datenexport herunter.
2. Entpacke den Export falls nötig.
3. In Claude Bridge **Chats importieren** wählen und die passende JSON-Datei auswählen.
4. Prüfe die importierten Chats. Öffne **Verwaltung & Statistiken** und aktiviere bei den gewünschten Chats **Synchronisiert**.

Der Importer erkennt übliche Felder wie `conversations`, `chats`, `chat_messages`, `messages` und `history`. Claude-Exportformate sind nicht garantiert identisch. Falls die Datei nicht erkannt wird, ist eine Anpassung an deine konkrete Exportdatei erforderlich.

## 5. Projektdateien
- `index.html`, `app.js`, `styles.css`: Chat- und Handy-Oberfläche.
- `admin.html`, `admin.js`: Admin-Dashboard.
- `supabase/schema.sql`: Datenbanktabellen, Authentifizierungsregeln (RLS) und Realtime.
- `manifest.json`, `sw.js`: PWA-Grundlage.
- `config.js`: öffentliche Supabase-Client-Konfiguration.

## Datenschutz
Alle Chat-Daten liegen in deinem Supabase-Projekt. RLS beschränkt den Zugriff auf den jeweils angemeldeten Benutzer. Teile keine Zugangsdaten, Session-Cookies oder privaten Claude-Exportdateien.