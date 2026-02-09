# Turkish Character Safety Rules

## CRITICAL: The Turkish İ/ı Problem

Turkish has 4 distinct i-related letters that break standard JavaScript case conversion:

| Lowercase | Uppercase | Standard JS | Correct (Turkish) |
|-----------|-----------|-------------|-------------------|
| i (dotted) | İ (dotted) | i → I ❌ | i → İ ✅ |
| ı (dotless) | I (dotless) | ı → I ❌ | ı → I ✅ |

```javascript
"istanbul".toUpperCase()           // "ISTANBUL"  ❌ (wrong: dotless I)
"istanbul".toLocaleUpperCase("tr") // "İSTANBUL"  ✅ (correct: dotted İ)

"İSTANBUL".toLowerCase()           // "i̇stanbul" ❌ (wrong: combining dot)
"İSTANBUL".toLocaleLowerCase("tr") // "istanbul"  ✅ (correct)
```

## Mandatory Rules

### String Case Conversion
- **NEVER** use `.toUpperCase()` or `.toLowerCase()` on user-facing strings
- **ALWAYS** use `toUpperCaseTR()` / `toLowerCaseTR()` from `lib/turkish-utils`
- This applies to: search, filter, sort, display, comparison, slug generation

### String Operations
- For search/filter: use `includesTR()` not `.includes()` (case-insensitive)
- For sorting: use `sortTR()` or `compareTR()` not `.sort()`
- For URL slugs: use `slugifyTR()` to properly map ç→c, ğ→g, ı→i, ö→o, ş→s, ü→u

### Encoding
- All files MUST be UTF-8 (enforced by .editorconfig)
- HTML: `<html lang="tr">` and `<meta charset="utf-8">`
- Database: UTF8 encoding with tr_TR.UTF-8 collation
- API responses: `Content-Type: application/json; charset=utf-8`
- Docker containers: `LANG=tr_TR.UTF-8` and `LC_ALL=tr_TR.UTF-8`

### Font Selection
- Always verify fonts support Turkish characters: ğ Ğ ı İ ö Ö ş Ş ü Ü ç Ç
- Safe Google Fonts: Inter, Nunito, Poppins, Roboto, Open Sans
- Test rendering before deploying

### Testing
- Always test with Turkish-specific strings: "İstanbul", "IĞDIR", "çiçek", "güneş"
- Test case conversion roundtrip: "İSTANBUL" → toLowerCase → toUpperCase → "İSTANBUL"
- Test sorting: ç should come after c, ö after o, ş after s, ü after u
- Test search: searching "istanbul" should find "İstanbul"
- Test slugs: "Güneş Çiçeği" → "gunes-cicegi"

## Available Utility Functions

Import from `lib/turkish-utils`:
- `toUpperCaseTR(str)` - Turkish-safe uppercase
- `toLowerCaseTR(str)` - Turkish-safe lowercase
- `capitalizeFirstTR(str)` - Capitalize first letter (Turkish-safe)
- `includesTR(str, search)` - Case-insensitive search (Turkish-safe)
- `compareTR(a, b)` - Turkish-safe string comparison
- `sortTR(arr, keyFn)` - Turkish-safe array sorting
- `slugifyTR(str)` - Turkish-safe URL slug generation
