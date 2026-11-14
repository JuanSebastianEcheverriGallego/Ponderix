# Guía 3 · Jhon Fernando Sánchez Álvarez (`@Jhonzn`)

**Rol:** Configuración de la Integración Continua (CI) en Azure DevOps.
**Turno:** 3 de 5 · **Fechas objetivo:** lun 16-nov → mar 17-nov-2026 (preparación desde el vie 13-nov).
**Recibes de:** David · **Entregas a:** Marbel · **Revisora de tus PR:** Marbel.

Eres el dueño de la **Actividad 1**: la pipeline `ponderix-ci` que se dispara sola con cada cambio en `main`, valida (restore/build/test) y publica el artefacto **`webapp`** que consumirá la CD. El artefacto es el «contrato» con Marbel: su nombre, contenido y ruta no deben cambiar sin avisarle.

---

## 0. HAZLO HOY (vie 13-nov): preparación que no depende de nadie

Estas tareas tardan días en resolverse si fallan, por eso empiezan antes de tu turno.

### 0.1 Organización y proyecto de Azure DevOps

> Si el equipo ya tiene una organización de prácticas anteriores con ejecuciones de pipelines funcionando, **reutilízenla** y creen solo el proyecto nuevo.

1. <https://dev.azure.com> → inicia sesión con tu cuenta Microsoft → **New organization** → nombre p. ej. `ponderix-equipo` → región cercana → **Continue**.
2. **Organization settings → Policies → Allow public projects: On** (recomendado: el docente podrá abrir los enlaces a las ejecuciones sin cuenta).
3. **+ New project** → **Project name:** `Ponderix` → **Visibility:** **Public** (o Private si la política anterior no está disponible; en ese caso las capturas en `evidencias/` son la prueba) → **Create**.
4. **Organization settings → Users → Add users**: agrega a los 4 compañeros (con la cuenta Microsoft/correo que usan en Azure DevOps), **Access level: Basic** (gratis hasta 5 usuarios), proyecto `Ponderix`:
   - Marbel → grupo **Project Administrators** (necesita crear Service Connections y entornos).
   - Juan Sebastián, David, Marlon → **Contributors**.

### 0.2 Capacidad de ejecución (paralelismo) — riesgo crítico

**Organization settings → Pipelines → Parallel jobs.** En *Microsoft-hosted*:

- Si ves **1800 minutos/mes (Free tier)** o más → listo.
- Si ves **0** → solicita la concesión gratuita en <https://aka.ms/azpipelines-parallelism-request> (indica *public* o *private* según el proyecto). Suele tardar **2–3 días hábiles**. Por eso se pide hoy.
- **Plan B si no llega a tiempo:** agente autohospedado en tu PC (ver `documentacion/05-solucion-errores.md`, error CI-01). Solo cambia `pool:` en el YAML.

📸 Captura de la pantalla de Parallel jobs (para la memoria, sección de problemas si hubo que solicitarlo).

## 1. Qué debes esperar antes de configurar la CI

- [ ] David confirmó que su PR está fusionado y que `dotnet test Ponderix.slnx` da 25/25 en `main`.
- [ ] Paralelismo disponible (o agente autohospedado listo).
- [ ] Juan Sebastián disponible ~10 minutos para instalar la GitHub App (solo el propietario del repo puede).

## 2. Material que tomas del repositorio de respaldo

`paquetes/03-jhon/pipelines/azure-pipelines-ci.yml` — pipeline completa:

| Parte | Qué hace |
|---|---|
| `trigger: main` | Cada push/merge a `main` lanza la CI automáticamente |
| `pr: main` | Cada PR hacia `main` se valida (solo etapa Validar) |
| Etapa **Validar** | `UseDotNet@2` (.NET 10) → `dotnet restore` → `dotnet build` → `dotnet test` → publica resultados (pestaña Tests) y cobertura |
| Etapa **Empaquetar** | Solo fuera de PR: `dotnet publish` → `buildinfo.json` (build, commit, rama, fecha) → `ponderix-<build>.zip` → artefacto **`webapp`** → etiqueta `commit-<sha7>` |
| `name: $(Date:yyyyMMdd)$(Rev:.r)` | Número de ejecución legible (p. ej. `20261117.2`) que aparece en el nombre del zip y en `/api/version` |

Se usan comandos `dotnet` (los mismos que en local) para que la CI sea **reproducible** en el PC de cualquier integrante.

## 3. Rama, commit y creación de la pipeline

```bash
git switch main
git pull origin main
git switch -c feature/jhon-pipeline-ci
mkdir -p pipelines
cp /c/respaldo-ponderix/paquetes/03-jhon/pipelines/azure-pipelines-ci.yml pipelines/
git status            # solo pipelines/azure-pipelines-ci.yml
git add pipelines/azure-pipelines-ci.yml
git commit -m "ci: agregar pipeline de CI con etapas Validar y Empaquetar y artefacto webapp"
git push -u origin feature/jhon-pipeline-ci
```

**Crear la pipeline en Azure DevOps** (todavía sin abrir el PR):

1. Proyecto `Ponderix` → **Pipelines → New pipeline** (o *Create Pipeline*).
2. **Where is your code?** → **GitHub** (YAML).
3. Autoriza Azure Pipelines con tu cuenta de GitHub si lo pide.
4. **Select a repository** → `JuanSebastianEcheverriGallego/ponderix`.
   - Si aparece **«Install the Azure Pipelines app»** o no ves el repo: es necesario que **Juan** (propietario) instale la app (guía de Juan, sección 9a), seleccionando solo el repo `ponderix` y la organización/proyecto `Ponderix`. Después vuelve a este paso.
5. **Configure your pipeline** → **Existing Azure Pipelines YAML file** → **Branch:** `feature/jhon-pipeline-ci` → **Path:** `/pipelines/azure-pipelines-ci.yml` → **Continue**.
6. En la vista previa, abre la flecha junto a **Run** → **Save** (no la ejecutes manualmente: la primera ejecución debe ser automática).
7. **Pipelines** → menú **⋯** de la pipeline recién creada → **Rename/move** → nombre **`ponderix-ci`** → **Save**.
   ⚠️ El nombre exacto importa: la CD lo referencia con `source: ponderix-ci`.

📸 `evidencias/02-ci/03-conexion-github.png` (Project settings → **GitHub connections** o Service connections, mostrando el repo enlazado) y `04-pipeline-ci-yaml.png` (pipeline `ponderix-ci` → Edit, mostrando la ruta del YAML).

## 4. Pull Request (y validación automática del PR)

GitHub → **Compare & pull request**:

- **Título:** `Pipeline de CI en Azure DevOps (ponderix-ci) con artefacto webapp`.
- **Descripción (además de la plantilla):** etapas, disparadores, nombre del artefacto y la ruta que usará la CD: `$(Pipeline.Workspace)/ci/webapp/ponderix-<build>.zip`.
- **Reviewer:** `JULIANA-s22`.

Al crear el PR, Azure DevOps lanza la CI con motivo **Pull request**: solo corre **Validar**; **Empaquetar** aparece como *Skipped*. En GitHub, el PR muestra el check de `ponderix-ci`.
📸 `evidencias/02-ci/08-validacion-pr.png` (checks del PR en GitHub).

Pide a **Juan** que marque ese check como obligatorio (guía de Juan, 9b). Indícale el nombre exacto que aparece en la lista de checks.

Cuando Marbel apruebe → **Create a merge commit**. No borres la rama.

## 5. Verificar la ejecución automática en `main`

Al fusionar, Azure DevOps lanza **sola** una nueva ejecución de `ponderix-ci`:

1. **Pipelines → ponderix-ci** → la ejecución más reciente:
   - **Motivo/Trigger:** *Individual CI* (o *Continuous integration*), **no** *Manual*.
   - **Rama:** `main` · **Commit:** el SHA del merge (compáralo con GitHub → Commits).
2. **Stages:** `Validar` ✅ → `Empaquetar` ✅.
3. Pestaña **Tests:** 25 superadas. Pestaña **Code Coverage** disponible.
4. **Artefactos:** en el resumen, «1 published» → **`webapp`** → contiene `ponderix-<build>.zip` y `buildinfo.json`. Descarga `buildinfo.json` y comprueba que `commit` coincide con el SHA del merge.
5. **Tags** de la ejecución: `commit-<7 primeros caracteres>`.

📸 `05-disparador-automatico.png`, `06-etapas-ci.png`, `07-artefacto-webapp.png` en `evidencias/02-ci/`.

## 6. Cambio controlado que demuestra el disparador (PR 2)

Este cambio es la evidencia de «provocar un nuevo cambio controlado en `main` y demostrar que la pipeline se ejecuta sin lanzarla manualmente».

1. Azure DevOps → `ponderix-ci` → **⋯ → Status badge** → *Branch:* `main` → copia el **Sample markdown**.
2. Rama y commit:

```bash
git switch main
git pull origin main
git switch -c feature/jhon-insignia-ci
```

3. En `README.md`, reemplaza la línea `[PENDIENTE: INSIGNIA DE ESTADO DE ponderix-ci]` por el markdown copiado y completa la sección 9 con:

```markdown
- Organización / proyecto: `[nombre de la organización]` / `Ponderix`
- Pipeline: [ponderix-ci](<enlace a la pipeline>)
- Ejecución de referencia: [<número>](<enlace a la ejecución>)
- Etapas: **Validar** (SDK .NET 10 → restore → build → test → resultados y cobertura) y **Empaquetar**
  (publish → buildinfo.json → ponderix-<build>.zip → artefacto `webapp`). En los PR solo se ejecuta Validar.
```

4. Commit, push y PR (revisora: Marbel):

```bash
git add README.md
git commit -m "docs(readme): agregar insignia de estado y documentar la pipeline de CI"
git push -u origin feature/jhon-insignia-ci
```

5. Tras el merge, anota la hora, el SHA del commit en `main` y el número de la ejecución de CI que arrancó sola. Esa terna es la evidencia del disparador.

## 7. No continúes hasta comprobar lo siguiente

- [ ] La pipeline se llama exactamente **`ponderix-ci`**.
- [ ] Hay al menos **dos** ejecuciones en `main` con motivo automático (merge del PR 1 y del PR 2).
- [ ] Las dos etapas terminaron en verde y la pestaña Tests muestra 25/25.
- [ ] El artefacto se llama **`webapp`** y contiene **un** `.zip` y `buildinfo.json` con el commit correcto.
- [ ] En un PR solo se ejecutó Validar (Empaquetar = Skipped).
- [ ] La CI es check obligatorio en `main` (Juan lo configuró).

## 8. Al finalizar mi parte debo entregar

| Entregable | A quién |
|---|---|
| Nombre exacto de la pipeline (`ponderix-ci`), nombre del artefacto (`webapp`) y ruta en CD: `$(Pipeline.Workspace)/ci/webapp/*.zip` | **Marbel** (siguiente) |
| Enlace a la última ejecución exitosa de CI en `main` | Marbel y Marlon |
| Nombre de la organización y del proyecto de Azure DevOps | Marbel, Marlon |
| Capturas 03–08 de `evidencias/02-ci/` | Marlon |
| Problemas encontrados en CI (síntoma, causa, solución) | README sección 16 y memoria (David) |

## 9. Qué explicas en los videos

- **Video 1 (CI) — eres el protagonista técnico:** «Soy Jhon Fernando Sánchez Álvarez, responsable de la CI». Muestra el YAML (trigger, pr, etapas, condición de Empaquetar), la conexión con GitHub, cómo el merge del cambio de Marlon lanza la CI **sin pulsar Run** (motivo *Individual CI* y mismo SHA que en GitHub), las etapas en verde, la pestaña Tests y el artefacto `webapp` con `buildinfo.json`. Justifica las decisiones: dos etapas para separar validación y empaquetado, no generar artefactos en PR, número de ejecución en el nombre del zip, comandos `dotnet` iguales a los locales.
- **Video 2 (CD):** muestra que la ejecución de CI del cambio v1.1.0 fue la que disparó la CD (en la ejecución de CD → recursos → `ci`).

## 10. Problemas frecuentes

Consulta `documentacion/05-solucion-errores.md` (errores CI-01 a CI-10): sin paralelismo, repo no visible, ejecución que no se dispara, `NETSDK1045`, «No test results found», artefacto vacío, nombre de pipeline incorrecto.
