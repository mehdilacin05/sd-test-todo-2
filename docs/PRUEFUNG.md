# Designprüfung: sd-test-todo-2
Stand: 2026-11-09 · Status: Designprüfung abgeschlossen, alle drei Befunde behoben
Unabhängig: ja – frischer Prüferkontext mit gpt-6-astra. Geprüft: Planungsdokumente, nicht Anwendungscode. Diese fachliche Prüfung ersetzt nicht die Freigabe durch Merge des Design-PR.

## Befunde (Originalwortlaut des Prüfers, drei Befunde)
1. Hoch – blockierend: „Backup entsteht, danach wird Nutzer A gesperrt oder gelöscht. Beim Restore enthält das Backup wieder Freigabe, Auth-Sitzung beziehungsweise gelöschte Daten. ‚Sperren/Löschungen erneut anwenden‘ benennt keine unabhängig erhaltene Quelle. Ohne diese kann der Betreiber die Änderungen nicht zuverlässig rekonstruieren; ein noch gültiges altes JWT könnte wieder Zugriff erhalten.“ Beleg im geprüften Stand: BAUPLAN.md:31, ARCHITEKTUR.md:114.
   → Eingearbeitet: BAUPLAN Abschnitt Betrieb/Restore-Sicherheitsgrenze, ARCHITEKTUR §8 und FREIGABE. Restore offline; alle Freigaben aus, alle Sitzungen/Refresh-Grants widerrufen. Separates dauerhaftes Betreiberjournal auf unabhängig vom DB-Restore gehaltenem Volume, vor jeder Sperr-/Löschoperation schreiben; bei fehlendem Journal geschlossen bleiben. Physische Löschungen erneut anwenden. Expliziter Test Backup → Sperre/Löschung → Restore → altes JWT abgewiesen/gelöschte Daten weg, plus fehlendes-Journal-Negativtest. Kein zusätzlicher Fachbereich/keine zusätzliche DB-Tabelle.
2. Mittel: „Konto wird per Cascade gelöscht oder eine spätere Contract-Migration entfernt Daten. Erst danach wird ein Fehler entdeckt. Ein altes App-Image stellt die Daten nicht wieder her; ein vollständiger Restore kann neuere Änderungen anderer Nutzer verlieren. Eine explizite Entscheidungsmatrix für diese Einbahnstraßen fehlt.“ Beleg: ARCHITEKTUR.md:21/:107/:113, BAUPLAN.md:31.
   → Eingearbeitet: BAUPLAN Tabelle Einbahnstraßen mit Entscheider/Punkt ohne Rückkehr/Rückwegkosten für Todo-/Kontolöschung, Sperre, destruktive Migration, Veröffentlichung/Promote. Destruktive Migration nur mit expliziter Entscheidung im bestehenden Merge-Freigabeschritt, keine vierte allgemeine Freigabestufe.
3. Niedrig/formal: „Gemessener Umfang 15.017 Byte überschreitet das Limit von 15.000 Byte um 17 Byte.“
   → Eingearbeitet: Architektur/ADRs gekürzt; finale Byteprüfung vor Versand erforderlich. FREIGABE höchstens 3.000 Byte.

## Wer prüft die Schritte?
Prüferurteil: „Für Schritte 1–5 nennt docs/BAUPLAN.md:13–14 Hosted-CI, unabhängigen Prüfer und menschlichen Merge. Lab-Nachweise sollen unabhängig mit Commit und Digest abgeglichen werden. Das ist ausreichend vorgesehen; der sichere Nachweiskanal bleibt ausdrücklich Voraussetzung vor Bau, nicht bereits gelöst.“
Autor: Je Schritt CI plus unabhängiger Prüfer, danach Mensch-Merge. Schritt 5 liefert Werkzeuge/Nachweise; Promote und Rollback erst in Stufe 06 nach gesondertem Ja. Keine alleinige Selbstabnahme durch Bauer.

## Einbahnstraßen
Siehe konkrete Entscheidungstabelle in BAUPLAN. Image-Rollback ist kein Daten-Rollback. Benutzerlöschung endgültig; spätere Löschungen/Sperren müssen Restore überleben. Betreiber entscheidet Wiederöffnung erst nach Abgleich und unabhängiger Prüfung.

## Bedrohungsmodell (manuell)
Werte: private Todos, Identitäten/Sitzungen, Freigaben, Secrets, Backups und Image-/Nachweisintegrität.
Akteure: anonym, A/B, gesperrte Nutzer, Betreiber, privilegierter Mailpit-Testjob, CI/Registry.
Grenzen: Browser/TLS/App/Auth/REST/RLS; Mailpit zu Identitätsübernahme; Hosted-CI zu privatem Lab; Staging zu prod; Backup zu aktuellem Sperr-/Löschzustand.
Annahmen: synthetisches geschlossenes Lab, Betreiber/Mailfänger privilegiert; aktuelles Journal separat erhalten. Hostverlust-Risiko akzeptiert. Betreiberpräzisierung nach Prüfung: Nachweise bleiben im Lab, unabhängig an Commit/Digest prüfen; V1-Monitor nur Kartenstillstand, kein unabhängiger App-/Host-Ausfallmonitor.
Einschränkung: hermes-security:threat-model ist nicht installiert; manuell anhand der Sicherheitsliste geprüft, kein installierter Spezialskill vorgetäuscht. grill-me angewandt: Warum nicht JWT allein? Was beweist der Link? Wer prüft Lab? Was bei Budgetende? Antworten in Architektur/ADR/Bauplan, keine zusätzliche Auftraggeberentscheidung durch Prüfer erfunden.

Geprüft: Plan, Rechte/Trust-Grenzen, Rollen, Einbahnstraßen, Dokumentgrenzen; technische Quellen separat vom Autor geprüft. Nicht geprüft: laufende App, reale TLS-/Backup-/RLS-/Lasttests, GitHub-Rechte/Kontingente, Standort/AVV. Diese bleiben Bau-/Auslieferungsnachweise.
Unabhängige Nachprüfung mit gpt-6-astra, Urteil im Originalwortlaut: „Alle drei bisherigen Befunde sind auf Designebene behoben. Unabhängig: ja.“ Und: „Keine verbliebenen konkreten Blocker aus diesen drei Befunden.“ Die Dokumentgrenzen werden vor dem Design-PR erneut geprüft. Kein Implementierungsurteil und keine Laufzeittests; keine Dateien durch Prüfer verändert. Bau startet erst nach menschlichem Merge des Design-PR. Die alte Slack-Antwort gilt nicht als Freigabe.
