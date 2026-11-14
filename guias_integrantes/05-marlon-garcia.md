# Guía 5 · Marlon García Sepúlveda (`@M3rl0n`)

**Rol:** Verificación extremo a extremo, evidencias, seguridad y coordinación de los videos.
**Turno:** 5 de 5 · **Fechas objetivo:** vie 20-nov → dom 22-nov-2026 (preparación desde el sáb 14-nov).
**Recibes de:** Marbel · **Entregas:** validación final al equipo · **Revisores:** Marbel (código) y Juan Sebastián (documentación).

Cierras el ciclo que pide el profesor: **un mismo cambio visible** que viaja GitHub → CI → artefacto → CD → Azure, demostrado con commit, ejecuciones y URL pública. También eres quien garantiza que las evidencias sean completas, legibles y verificables.

---

## 0. Preparación adelantada (desde el sáb 14-nov, en paralelo)

- [ ] Acepta la invitación al repo y configura Git:
  ```bash
  git config --global user.name "Marlon García Sepúlveda"
  git config --global user.email "<correo de tu cuenta de GitHub>"
  ```
- [ ] Prueba tus scripts en local contra la app: ejecuta en el respaldo `bash scripts/ensamblar-y-verificar.sh` (ensambla todo, arranca la app y corre `verificar-despliegue.sh`). Debe terminar con «RESULTADO: verificación superada».
- [ ] Revisa `evidencias/README.md` (lista de capturas y responsables) y recoge las capturas que te vayan enviando.
- [ ] Prepara la sesión de grabación (fecha, herramienta, orden) con `videos/` del respaldo y crea el canal de YouTube o la cuenta donde se publicarán (visibilidad **No listado**).

## 1. Qué debes esperar antes de comenzar

- [ ] Marbel confirmó: URL pública funcionando y **CD disparada automáticamente** al menos una vez.
- [ ] La aplicación publicada muestra **Versión 1.0.0**.
- [ ] Todo el equipo disponible para la sesión de grabación (vie 20-nov).

## 2. Material que tomas del repositorio de respaldo

`paquetes/05-marlon/`:

| Archivo | Para qué |
|---|---|
| `scripts/verificar-despliegue.sh` / `.ps1` | Comprueba salud, versión, **commit publicado = commit esperado**, cálculo real (4.75), validación 400 y página web |
| `scripts/buscar-secretos.sh` / `.ps1` | Busca credenciales en archivos versionados y en todo el historial |
| `src/Ponderix.Api/AppInfo.cs` | Referencia del **cambio visible** (1.0.0 → 1.1.0) |
| `CHANGELOG.md` | Historial con la entrada 1.1.0 |

## 3. PR 1 — scripts de verificación y seguridad

```bash
git switch main
git pull origin main
git switch -c feature/marlon-verificacion
mkdir -p scripts
cp /c/respaldo-ponderix/paquetes/05-marlon/scripts/verificar-despliegue.* scripts/
cp /c/respaldo-ponderix/paquetes/05-marlon/scripts/buscar-secretos.* scripts/
git status        # solo 4 archivos nuevos en scripts/

git add scripts/verificar-despliegue.sh scripts/verificar-despliegue.ps1
git commit -m "test(e2e): agregar script de verificación funcional del despliegue"

git add scripts/buscar-secretos.sh scripts/buscar-secretos.ps1
git commit -m "chore(seguridad): agregar búsqueda de credenciales en archivos e historial"
git push -u origin feature/marlon-verificacion
```

PR **«Scripts de verificación extremo a extremo y búsqueda de secretos»**, reviewer `JULIANA-s22`, merge commit.
Este merge también dispara CI → CD (otra prueba de automatización; la app sigue en 1.0.0).

Ejecuta ahora contra Azure (debe pasar todo):

```bash
./scripts/verificar-despliegue.sh https://ponderix-<sufijo>.azurewebsites.net
./scripts/buscar-secretos.sh
# PowerShell:
# .\scripts\verificar-despliegue.ps1 -Url https://ponderix-<sufijo>.azurewebsites.net
# .\scripts\buscar-secretos.ps1
```

📸 `evidencias/05-equipo/02-buscar-secretos.png` y `evidencias/04-extremo-a-extremo/01-app-antes-v1-0-0.png` (navegador con la URL pública mostrando «Versión 1.0.0»).

## 4. PR 2 — EL cambio visible (se hace durante la grabación)

> Este es el cambio que el profesor quiere seguir de punta a punta. Se ejecuta **en vivo** durante la sesión de grabación (sección 6). Prepara la rama antes, pero **no la fusiones** hasta que el equipo esté grabando.

```bash
git switch main
git pull origin main
git switch -c feature/marlon-version-1-1
```

Edita `src/Ponderix.Api/AppInfo.cs` (dos líneas):

```csharp
    public const string Version = "1.1.0";

    public const string Novedad = "Nueva versión desplegada automáticamente: GitHub → CI → CD → Azure.";
```

Agrega al inicio de `CHANGELOG.md` (debajo del título):

```markdown
## [1.1.0] — Cambio visible para la demostración extremo a extremo

- Nueva versión y mensaje de novedad visibles en la cabecera y el pie de la aplicación.
```

Comprueba en local y sube:

```bash
dotnet test Ponderix.slnx           # 25/25 (la prueba de versión usa la constante, no un valor fijo)
dotnet run --project src/Ponderix.Api --launch-profile http   # cabecera: "Versión 1.1.0: Nueva versión…"
git add src/Ponderix.Api/AppInfo.cs CHANGELOG.md
git commit -m "feat(web): publicar versión 1.1.0 con novedad visible para la demostración CI/CD"
git push -u origin feature/marlon-version-1-1
```

Abre el PR **«Versión 1.1.0: cambio visible para demostrar GitHub → CI → CD → Azure»**, reviewer `JULIANA-s22`. Espera a que la validación de CI del PR esté en verde y a la aprobación, **pero fusiona durante la grabación**.

## 5. Verificación extremo a extremo (después del merge en vivo)

Anota en una tabla (va al README sección 12 y a la memoria):

| Paso | Dato a anotar | Dónde verlo |
|---|---|---|
| PR | número y enlace | GitHub → Pull requests |
| Commit en `main` | SHA del merge commit | GitHub → Commits de `main` |
| CI | número de ejecución (p. ej. `20261120.1`), motivo automático, mismo SHA | Azure DevOps → `ponderix-ci` |
| Artefacto | `webapp/ponderix-<build>.zip` y `buildinfo.json` | Ejecución de CI → artefactos |
| CD | ejecución «CD de CI <build>», disparada por `ponderix-ci` | Azure DevOps → `ponderix-cd` |
| Azure | página muestra «Versión 1.1.0»; `/api/version` → mismo `commit` y `build` | Navegador |

Y ejecuta:

```bash
git pull origin main
./scripts/verificar-despliegue.sh https://ponderix-<sufijo>.azurewebsites.net     # usa origin/main como commit esperado
```

📸 Capturas `02` a `08` de `evidencias/04-extremo-a-extremo/` (lista exacta en `evidencias/README.md`).

## 6. Coordinación de la sesión de grabación (vie 20-nov)

Tú moderas y compartes el guion (`videos/guion-video-1-ci.md` y `videos/guion-video-2-cd.md`):

1. Reunión de Teams (o Zoom/OBS) **grabada**, cámara opcional, cada persona comparte su pantalla en su turno.
2. Antes de grabar: todos con sesión iniciada en GitHub, Azure DevOps y Azure; pestañas abiertas según el guion; notificaciones silenciadas; nada sensible visible.
3. Se graba en **una toma continua** el cambio v1.1.0 (CI ≈ 3–5 min; CD ≈ 3–5 min).
4. Se edita en dos videos: Video 1 termina cuando el artefacto está publicado; Video 2 empieza con la CD disparada.
5. Publicación en YouTube como **No listado**; comprueba que los enlaces abren en una ventana privada sin sesión.

## 7. PR 3 — evidencias y cierre de documentación (sáb 21 → dom 22-nov)

```bash
git switch main
git pull origin main
git switch -c feature/marlon-evidencias
# Copia las capturas reales a evidencias/<subcarpeta>/ con los nombres de evidencias/README.md
```

Completa en `README.md`: sección 12 (tabla de trazabilidad con enlaces reales), sección 14 (enlaces de los videos), enlaces a los PR de cada integrante en la tabla del equipo, y revisa que **no quede ningún `[PENDIENTE`**:

```bash
git grep -n "PENDIENTE"          # debe devolver vacío al final
git add evidencias
git commit -m "docs(evidencias): agregar capturas de CI, CD y verificación extremo a extremo"
git add README.md
git commit -m "docs(readme): completar trazabilidad del cambio v1.1.0, videos y enlaces finales"
git push -u origin feature/marlon-evidencias
```

PR **«Evidencias, trazabilidad y enlaces finales»**, reviewer `JuanSebastianEcheverriGallego`.

## 8. No continúes hasta comprobar lo siguiente (validación final)

- [ ] La URL pública muestra **1.1.0** y `verificar-despliegue` termina en «verificación superada».
- [ ] El SHA del merge v1.1.0 aparece igual en: GitHub, ejecución de CI, `buildinfo.json`, paso de trazabilidad de la CD y `/api/version`.
- [ ] `buscar-secretos` sin hallazgos.
- [ ] Todas las capturas de `evidencias/README.md` existen y se leen bien.
- [ ] Los dos videos abren sin sesión y cada integrante se presenta y explica su parte.
- [ ] `git grep PENDIENTE` vacío en `main`.
- [ ] Recorriste `documentacion/09-matriz-rubricas.md` y `entregables/checklist-entrega-teams.md`.

## 9. Al finalizar mi parte debo entregar

| Entregable | A quién |
|---|---|
| Tabla de trazabilidad completa (sección 5) | README + David (memoria) |
| Enlaces de YouTube de ambos videos | README + Teams |
| PR de evidencias fusionado | Equipo |
| PDF de la memoria revisado | Entrega en Teams (con David) |
| Entrega en Teams: enlace al repo, 2 videos, PDF | Docente (lun 23-nov, antes de las 12:00) |

## 10. Qué explicas en los videos

- **Video 1 (CI):** «Soy Marlon García Sepúlveda, responsable de la verificación y las evidencias». Muestras el PR del cambio v1.1.0, lo fusionas en vivo y señalas el SHA del commit en `main` que activará la CI.
- **Video 2 (CD):** cierras la demostración: abres la URL pública (1.1.0 visible), `/api/version` con el mismo commit y build, ejecutas `verificar-despliegue` y muestras el cálculo real en la interfaz. Resumes la cadena completa con los datos de la tabla de trazabilidad.

## 11. Problemas frecuentes

| Síntoma | Solución |
|---|---|
| La URL sigue mostrando 1.0.0 tras la CD | Refresca sin caché (Ctrl+F5); revisa que la prueba de humo de la CD pasó; ver CD-07. |
| `verificar-despliegue` falla en el commit | Ejecuta `git pull` antes (compara con `origin/main`) o pasa el SHA como segundo argumento. |
| `buscar-secretos` marca un falso positivo | Revisa la línea; si es texto de documentación, reescríbelo; si es un secreto real, sigue `documentacion/06-seguridad.md`. |
| El video no se ve sin sesión | En YouTube, visibilidad **No listado** (no *Privado*). |
