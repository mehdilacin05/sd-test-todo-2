# Entwurf – nicht installiert

Die Dateien stammen aus dem Skill software-projekt und sind **keine aktiven Workflows**. Installation und Änderungen an `.github/workflows/` sind ausschließlich dem Menschen vorbehalten.

Vor einer Installation muss der Betreiber ARM-Builds, Checks auf dem exakten PR-Commit, den vollständig getrennten Lab-Nachweis und Magic-Link-Tests statt des Passwort-E2E anpassen und separat prüfen. Insbesondere ist der ursprüngliche `staging-e2e`-Job für dieses private Lab ungeeignet; ein übersprungener Job ist kein Lab-Nachweis. Publish und Promote erst nach der im Bauplan vorgesehenen Prüfung/Freigabe verwenden. Keine Workflows durch diese Karte installieren.
