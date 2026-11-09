# 001 · Supabase mit Live-Sperre
Datum: 2026-11-09 · Status: vorgeschlagen bis Merge des Design-PR
## Lage
Private Todos, Magic Link, sofortige Sperre alter Tokens.
## Optionen
| Option | Vorteil | Preis |
|---|---|---|
| Nur JWT | Einfach | Sperre verzögert |
| Supabase + RLS-Liveprüfung | Direkte API geschützt | Zweite Tabelle/Helfer |
| Eigene Auth | Kontrolle | Unnötiges Sicherheitsrisiko |
## Entscheidung
Option 2: Besitz plus Freigabe/Ban/Sitzung prüfen. Nur Betreiber schreibt Status; App nutzt Nutzer-Token. Mailpit statt externer Mail, Signup aus.
## Folgen
Schemaabhängigkeit bei Upgrades testen. Sperre gilt ab Commit für neue Anfragen, nicht rückwirkend. Bigint-ID statt UUID für Vorlagensortierung, IDs ersetzen keine Rechte.
