# Test V2 to V3 Migration Sample

Ce projet d'exemple est conçu pour tester et valider le script de migration automatique de NeoCore v2 vers v3.

## Objectif

Ce projet simule un projet NeoCore v2 typique avec les patterns et configurations qui nécessitent une migration vers v3.

## Contenu du projet

### Fichiers de configuration v2 (à migrer)

- **`manifest.xml`** : Version 2.1.0 (sera mise à jour vers 3.x)
- **`project.xml`** : Contient des patterns v2 qui nécessitent migration :
  - `buildPath` et `distPath` avec chemins absolus (au lieu de templates `{{neocore}}`)
  - `includePath`, `libraryPath`, `crtPath` avec chemins absolus
  - Configuration DAT avec `starting_tile` (deprecated en v3)
  - Chemin RAINE avec `raine32.exe` (warning en v3)

### Code source avec patterns v2

- **`main.c`** : Contient du code utilisant des patterns v2 :
  - Typedefs supprimés : `Hex_Color`, `Hex_Packed_Color`
  - Fonctions utilisant ces typedefs : `nc_log_rgb16()`, `nc_log_packed_color16()`

## Test de migration

### 1. État initial (v2)
```bash
# Le projet devrait avoir ces caractéristiques v2 :
- manifest.xml version: 2.1.0
- project.xml avec chemins absolus
- main.c avec typedefs supprimés
```

### 2. Exécution du script de migration
```bash
cd neocore/bootstrap/scripts/project
upgrade.bat -projectSrcPath "..\..\..\..\samples\test_v2tov3" -projectNeocorePath "..\..\..\..\samples\test_v2tov3"
```

### 3. Résultat attendu après migration
```bash
# Le script devrait automatiquement :
- Mettre à jour manifest.xml vers 3.x
- Corriger les chemins dans project.xml (templates {{neocore}}, {{build}})
- Créer des backups (.v2.backup)
- Rapporter les issues du code source (typedefs)
- Afficher un résumé de migration
```

### 4. Validation post-migration

**Changements automatiques attendus :**
- ✅ `manifest.xml` : 2.1.0 → 3.0.0-rc
- ✅ `project.xml` : chemins absolus → templates
- ✅ Backups créés

**Issues restantes (migration manuelle requise) :**
- ⚠️ `main.c` : typedefs supprimés nécessitent correction manuelle
- ⚠️ Compilation échouera jusqu'à correction du code

## Complexité de migration estimée

- **Configuration XML** : 1/10 (automatique)
- **Code source** : 4/10 (semi-automatique)
- **Temps total** : 5-10 minutes (vs 2-4 heures en manuel)

## Utilisation

Ce projet sert de :
1. **Test de validation** pour le script d'upgrade
2. **Exemple de référence** pour les développeurs
3. **Benchmark de complexité** pour évaluer l'efficacité de la migration automatique
