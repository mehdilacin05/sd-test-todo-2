# 002 · Zwei Lab-Stacks, ein Image
Datum: 2026-11-09 · Status: vorgeschlagen bis Merge des Design-PR
## Lage
ARM-Lab, GHCR-Pull, keine Zusatzkosten.
## Optionen
| Option | Vorteil | Preis |
|---|---|---|
| Cloud | Wenig Betrieb | Widerspricht Auftrag |
| Zwei Compose-Stacks | Testtrennung | Eigene Backups/Updates |
| Gemeinsame DB | Spart RAM | Datenvermischung |
## Entscheidung
Zwei Stacks, getrennte Daten/Schlüssel, gleicher App-Digest, manuelle Promotion. Lab-Nachweis unabhängig prüfen, Hosted-CI ohne Lab-Zugang.
## Folgen
Eigenes Backup-Volume statt externer Kopie akzeptiert: Hostverlust kann alles vernichten. Mailfänger-Leser können Nutzer imitieren. Standort/Kontingente vor Nutzung prüfen; V1-Monitor nur Agentenstillstand, kein Host-Ausfallmonitor, keine kostenpflichtigen Zusagen.
