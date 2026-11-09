# Freigabe Design: sd-test-todo-2
Stand: 2026-11-09 · Klasse S · Heikel: Login mit personenbezogenen Daten
Status: Zur Freigabe per Merge des Design-PR; noch nicht freigegeben.

App-Typ: internes Lab-Werkzeug. Private Todos im Browser; Magic Link, anlegen, abhaken, löschen, abmelden. Deutsch, mobil nutzbar. Kein Anwendungscode vor Merge des Design-PR.

Architektur in fünf Zeilen
1. Next.js/TypeScript plus selbst betriebenes Supabase, keine Cloud.
2. Zwei eigene Tabellen: Todos und private Nutzerfreigabe. Datenbankrechte schützen auch direkte Anfragen; Sperren entziehen alten Tokens den Zugriff.
3. Login-Mails nur an internen Mailfänger; keine freie Registrierung, kein Passwortlogin. Mailfänger nur für Betreiber/Tests: kein Beweis echter Mailinhaberschaft.
4. Staging/prod als getrennte Compose-Stacks im ARM-Lab; GHCR-Pull, ein Image unverändert, Merge und Promote nur menschlich freigegeben.
5. Tägliches Backup, sieben Stände, Restore-Übung; Slack-Alarme, Reaktion werktags 09–18 Asia/Tokyo.

Bauplan: 1 Gerüst/Prüftor, 2 Daten/RLS/Lab-Stack, 3 Magic Link, 4 Todo-Oberfläche, 5 Sicherheits-/Betriebsnachweise. Jeder Schritt mit automatischen Tests, unabhängigem Review und separatem PR. Abnahme: zwei Konten, kein Fremdzugriff, Backup/Restore belegt; Lastziel 20/s, p95 <500 ms.

Zusätzliche Kosten: 0 bei vorhandenen Ressourcen/Kontingenten. Keine Zukäufe; bei Erschöpfung stoppen. Kein Termin. GitHub-Plan unbekannt: keine kostenpflichtigen Schutzfunktionen zugesagt.

Annahmen/Abweichungen zur Bestätigung
1. Todo maximal 2.000 Zeichen, Listen seitenweise 100; Lab-TLS über lokale CA.
2. Backup nur eigenes Volume: kompletter Serververlust nicht abgesichert. Max. Datenverlust 24h, Restore-Ziel 4h bei verfügbarem Backup/Host.
3. Synthetische Testkonten bis Standort/Datenschutz geprüft. Kein öffentlicher Betrieb.
4. Betreiberpräzisierung: Nachweise bleiben im Lab, Commit/Digest unabhängig prüfen. V1-Monitor ist der Stillstand-Job für Agentenkarten, kein App-/Host-Ausfallmonitor.

Prüfbefunde (unabhängige Stufe 04): Restore könnte Sperren/Löschungen zurückdrehen → offline wiederherstellen, alle Sitzungen sperren, separates Betreiberjournal abgleichen und testen. Einbahnstraßen → Entscheider/Rückweg dokumentiert. Dokumentlänge → gekürzt. Details: docs/PRUEFUNG.md.
Einrichtung, Hermes-Route und GitHub-Webhook laut Betreiber abgeschlossen. Workflow-Vorschläge kommen im Gerüst-PR unter ci-vorschlag/; Installation auf dessen Branch durch den Betreiber.

Details im Design-PR: docs/ARCHITEKTUR.md, docs/BAUPLAN.md, docs/PRUEFUNG.md, docs/entscheidungen/.
Freigabeweg: Merge des Design-PR durch den Auftraggeber. Eine Kanalantwort ohne Merge gibt nichts frei.
