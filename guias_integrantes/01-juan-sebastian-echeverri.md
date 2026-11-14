# Guía 1 · Juan Sebastián Echeverri Gallego (`@JuanSebastianEcheverriGallego`)

**Rol:** Gestión de GitHub, aplicación base y documentación (README).
**Turno:** 1 de 5 · **Fechas objetivo:** vie 13-nov → sáb 14-nov-2026.
**Revisor de tu PR:** David (`@Davdfranco`).

Tú abres el camino: sin repositorio, sin aplicación y sin protección de `main`, nadie más puede trabajar. Además eres el **propietario del repositorio**, así que hay dos tareas administrativas que solo tú puedes hacer más adelante (instalar la GitHub App de Azure Pipelines y añadir el check obligatorio de la CI).

---

## 0. Qué debes esperar antes de comenzar

Nada: eres el primero. Solo necesitas:

- [ ] Cuenta de GitHub `JuanSebastianEcheverriGallego` con verificación en dos pasos activada.
- [ ] Git instalado (`git --version`) y configurado con tu nombre y correo de GitHub:
  ```bash
  git config --global user.name "Juan Sebastián Echeverri Gallego"
  git config --global user.email "<el correo asociado a tu cuenta de GitHub>"
  ```
  Usa el correo de GitHub (o el `noreply` de GitHub en Settings → Emails) para que los commits aparezcan enlazados a tu perfil.
- [ ] .NET SDK 10 instalado (`dotnet --version` → `10.0.x`).
- [ ] Haber descargado el repositorio de respaldo (ZIP o `git clone`) en una carpeta distinta, por ejemplo `C:\respaldo-ponderix`.

## 1. Material que tomas del repositorio de respaldo

Todo el contenido de `paquetes/01-juan-sebastian/` (incluye archivos ocultos `.gitignore`, `.gitattributes`, `.editorconfig` y la carpeta `.github/`):

| Archivo / carpeta | Para qué sirve |
|---|---|
| `src/Ponderix.Api/` | Aplicación completa (API + interfaz web) |
| `Ponderix.slnx`, `global.json` | Solución y versión fija del SDK .NET 10 |
| `.gitignore`, `.gitattributes`, `.editorconfig` | Higiene del repo; `.gitignore` bloquea secretos |
| `README.md` | README oficial con marcadores `[PENDIENTE: …]` que cada integrante completa |
| `CONTRIBUTING.md`, `.github/pull_request_template.md` | Reglas de ramas/commits/PR y plantilla de PR |
| `CHANGELOG.md` | Historial de versiones (1.0.0) |
| `evidencias/` | Estructura de carpetas de capturas + índice |

> En el Explorador de Windows activa **Ver → Mostrar → Elementos ocultos** para ver los archivos que empiezan por punto.

## 2. Crear el repositorio en GitHub

1. GitHub → **+ → New repository**.
2. **Owner:** tu usuario. **Repository name:** `PonderixOficial`.
3. **Description:** `Calculadora de notas ponderadas · CI/CD con Azure DevOps y Azure App Service`.
4. **Visibility:** **Public** (recomendado: protección de ramas, *secret scanning* y lectura de evidencias gratis). Si el equipo prefiere *Private*, la protección de ramas exige GitHub Pro (gratis con el GitHub Student Developer Pack).
5. **NO** marques «Add a README», «.gitignore» ni licencia (el repo debe nacer vacío).
6. **Create repository**. Copia la URL: `https://github.com/JuanSebastianEcheverriGallego/PonderixOficial.git`.

## 3. Primer commit en `main` (el único que se sube directo)

```bash
# 1. Crear la carpeta de trabajo y entrar en ella
mkdir PonderixOficial
cd PonderixOficial

# 2. Inicializar Git con la rama principal llamada main
git init -b main

# 3. Copiar SOLO .gitignore y .gitattributes desde el respaldo (ajusta la ruta)
cp /c/respaldo-ponderix/paquetes/01-juan-sebastian/.gitignore .
cp /c/respaldo-ponderix/paquetes/01-juan-sebastian/.gitattributes .
#   (PowerShell: Copy-Item C:\respaldo-ponderix\paquetes\01-juan-sebastian\.gitignore .)

# 4. README mínimo inicial
echo "# Ponderix" > README.md

# 5. Confirmar y subir
git add .gitignore .gitattributes README.md
git commit -m "chore: inicializar repositorio con .gitignore y .gitattributes"
git remote add origin https://github.com/JuanSebastianEcheverriGallego/PonderixOficial.git
git push -u origin main
```

**Resultado esperado:** en GitHub aparece la rama `main` con 3 archivos.

## 4. Proteger `main`

GitHub → repo → **Settings → Branches → Add branch ruleset** (o *Add classic branch protection rule*):

- **Ruleset name:** `proteccion-main` · **Enforcement:** Active · **Target branches:** *Include default branch*.
- Marca **Restrict deletions** y **Block force pushes**.
- Marca **Require a pull request before merging** → *Required approvals*: **1**.
- (Más adelante, cuando Jhon tenga la CI: **Require status checks to pass** → añadir el check de `ponderix-ci`. Ver sección 9.)
- **Create**.

📸 Captura `evidencias/01-repositorio/03-proteccion-main.png`.

## 5. Invitar a los colaboradores (incluido el docente)

GitHub → **Settings → Collaborators → Add people** y escribe **el usuario**, no el correo:

| Usuario | Motivo |
|---|---|
| `Davdfranco` | Integrante |
| `Jhonzn` | Integrante |
| `JULIANA-s22` | Integrante |
| `M3rl0n` | Integrante |
| **`oalarconpe`** | **Docente (obligatorio, por usuario de GitHub)** |

Comprueba en la misma pantalla que `oalarconpe` aparece (primero como *Pending invite*; cuando el docente acepte, como colaborador). Si sigue pendiente cerca de la entrega, deja constancia con la captura y avísalo en Teams.

📸 `evidencias/01-repositorio/02-colaboradores-oalarconpe.png`.

Activa también **Settings → Code security → Secret scanning** y **Push protection** (disponibles gratis en repos públicos).

## 6. Rama de trabajo y commits de la aplicación

```bash
# 1. Asegurarte de estar al día
git switch main
git pull origin main

# 2. Crear tu rama
git switch -c feature/juan-sebastian-base-aplicacion

# 3. Copiar TODO el paquete 01 sobre la carpeta del repo (sobrescribe README.md, es lo esperado)
cp -r /c/respaldo-ponderix/paquetes/01-juan-sebastian/. .
#   (PowerShell: Copy-Item -Recurse -Force C:\respaldo-ponderix\paquetes\01-juan-sebastian\* . ;
#    luego copia también .editorconfig y la carpeta .github, que Copy-Item * omite por ser ocultos)

# 4. Ver qué hay nuevo
git status
```

Haz **cinco commits**, cada uno con un grupo coherente de archivos (así el historial muestra avances reales):

```bash
git add global.json Ponderix.slnx .editorconfig src/Ponderix.Api/Ponderix.Api.csproj src/Ponderix.Api/appsettings.json src/Ponderix.Api/appsettings.Development.json src/Ponderix.Api/Properties
git commit -m "chore: crear proyecto ASP.NET Core 10 y solución Ponderix"

git add src/Ponderix.Api/AppInfo.cs src/Ponderix.Api/Dominio
git commit -m "feat(dominio): agregar cálculo de notas ponderadas y niveles de la rúbrica"

git add src/Ponderix.Api/Program.cs src/Ponderix.Api/Infraestructura
git commit -m "feat(api): exponer endpoints de salud, versión, rúbricas y cálculo"

git add src/Ponderix.Api/wwwroot
git commit -m "feat(web): agregar interfaz web de la calculadora"

git add README.md CONTRIBUTING.md CHANGELOG.md .github evidencias
git commit -m "docs: agregar README, guía de contribución, plantilla de PR y carpeta de evidencias"
```

Antes de subir, **verifica que funciona**:

```bash
dotnet build Ponderix.slnx           # → "0 Advertencia(s) 0 Errores"
dotnet run --project src/Ponderix.Api --launch-profile http
```

Abre <http://localhost:5080>: carga la plantilla de CI, calcula una nota y el pie muestra `Ponderix v1.0.0 · build local`. Prueba <http://localhost:5080/health> → `Healthy`. Detén con `Ctrl+C`.

```bash
git status                 # no debe aparecer bin/ ni obj/ (los ignora .gitignore)
git log --oneline          # 6 commits (el inicial + 5)
git push -u origin feature/juan-sebastian-base-aplicacion
```

## 7. Pull Request

GitHub → **Compare & pull request**:

- **Base:** `main` ← **compare:** `feature/juan-sebastian-base-aplicacion`.
- **Título:** `Aplicación base Ponderix (.NET 10), README y reglas de colaboración`.
- **Descripción:** se carga la plantilla; complétala. Texto sugerido:
  > Agrega la API Minimal .NET 10 con `/health`, `/api/version`, `/api/rubricas` y `POST /api/notas/calcular`, la interfaz web, el README oficial con marcadores pendientes, CONTRIBUTING, plantilla de PR y la estructura de `evidencias/`. Verificado con `dotnet build` (0 advertencias) y ejecución local. Habilita: David puede crear el proyecto de pruebas sobre esta solución.
- **Reviewers:** `Davdfranco`. **Assignees:** tú.
- **Create pull request**.

Cuando David apruebe: **Merge pull request → Create a merge commit → Confirm**. **No borres la rama** (botón *Delete branch*): sirve de evidencia hasta la entrega.

```bash
git switch main
git pull origin main       # tu main local ya incluye el merge
```

## 8. Tareas que haces en paralelo mientras los demás avanzan

- **Revisar el PR de David** (pruebas): clona/actualiza, ejecuta `dotnet test Ponderix.slnx`, comenta y aprueba.
- **Instalar la GitHub App «Azure Pipelines»** cuando Jhon te lo pida (sección 9). Solo el propietario del repo puede hacerlo.
- Preparar tu segmento de los videos y tu apartado de la memoria PDF (secciones 1–8 y 21; ver `documentacion/07-memoria-tecnica.md`).
- Revisar los PR de documentación de Marlon al final.

## 9. Tareas administrativas que te pedirá Jhon

**a) Autorizar Azure Pipelines en el repo** (cuando Jhon cree la pipeline):
Jhon te enviará una solicitud o te pedirá unirte a una llamada corta. Ve a <https://github.com/apps/azure-pipelines> → **Configure** → tu cuenta → **Only select repositories → `PonderixOficial`** → **Save/Install** → en la pantalla de Azure DevOps elige la organización y el proyecto `Ponderix` que creó Jhon (debes ser miembro del proyecto).

**b) Hacer obligatoria la CI en `main`** (después del primer PR validado por la CI):
Settings → Rules/Branches → `proteccion-main` → **Require status checks to pass** → buscar el check que te indique Jhon (p. ej. `ponderix-ci`) → **Save**.

📸 Actualiza `evidencias/01-repositorio/03-proteccion-main.png` con el check incluido.

## 10. No continúes hasta comprobar lo siguiente

- [ ] El repo se llama `PonderixOficial` (no `practica-final` ni similares) y la rama por defecto es `main`.
- [ ] `oalarconpe` aparece en Collaborators (aceptado o invitación pendiente) y los 4 integrantes aceptaron.
- [ ] `main` está protegida (PR + 1 aprobación, sin force push).
- [ ] El PR está **fusionado** con merge commit y `main` compila (`dotnet build Ponderix.slnx`).
- [ ] La rama `feature/juan-sebastian-base-aplicacion` sigue existiendo.
- [ ] `git ls-files` no muestra `bin/`, `obj/`, `.env` ni archivos de credenciales.

## 11. Al finalizar mi parte debo entregar

| Entregable | A quién | Cómo |
|---|---|---|
| URL del repo `https://github.com/JuanSebastianEcheverriGallego/PonderixOficial` | Todo el equipo | Chat del equipo |
| Enlace al PR fusionado | David y Marlon (evidencias) | Chat |
| Confirmación «`main` lista para pruebas» | **David** (siguiente) | Chat |
| Capturas 01, 02 y 03 de `evidencias/01-repositorio/` | Marlon | Carpeta compartida o PR de evidencias |
| Disponibilidad para la instalación de la GitHub App | Jhon | Chat |

## 12. Qué explicas en los videos

- **Video 1 (CI):** «Soy Juan Sebastián Echeverri Gallego, responsable de GitHub y documentación». Muestra el repo `PonderixOficial`, la rama `main`, la regla de protección, los colaboradores (incluido `oalarconpe`), el historial de commits/PR y el README. Explica por qué se trabaja con ramas + PR y merge commit (trazabilidad por autor).
- **Video 2 (CD):** muestra el PR del cambio visible v1.1.0 de Marlon y su commit de fusión en `main` (el inicio de la cadena), y la sección de trazabilidad del README.

## 13. Problemas frecuentes

| Síntoma | Solución |
|---|---|
| `git push` pide usuario/contraseña y falla | GitHub no acepta contraseñas: usa Git Credential Manager (se abre el navegador) o `gh auth login`. |
| No aparecen `.gitignore`/`.github` al copiar en Windows | Copia con Git Bash (`cp -r carpeta/. .`) o activa «Elementos ocultos». |
| `dotnet build` dice que no encuentra el SDK 10.0.100 | Instala .NET SDK 10 (cualquier 10.0.x sirve: `global.json` usa `rollForward: latestFeature`). |
| Commits aparecen sin tu foto en GitHub | El `user.email` no coincide con tu cuenta; corrígelo para los siguientes commits. |
