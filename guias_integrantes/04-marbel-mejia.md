# Guía 4 · Marbel Juliana Mejía Bedoya (`@JULIANA-s22`)

**Rol:** Configuración de la Entrega Continua (CD) y de Azure App Service.
**Turno:** 4 de 5 · **Fechas objetivo:** mié 18-nov → jue 19-nov-2026 (preparación de Azure desde el dom 15-nov).
**Recibes de:** Jhon · **Entregas a:** Marlon · **Revisor de tus PR:** Jhon.

Eres la dueña de la **Actividad 2**: el App Service donde vive la aplicación y la pipeline `ponderix-cd`, que se dispara sola cuando `ponderix-ci` termina bien en `main`, descarga **ese** artefacto `webapp` (sin recompilar) y lo publica en Azure.

---

## 0. Preparación adelantada (desde el dom 15-nov, en paralelo con Jhon)

No necesitas la CI para preparar Azure. Hazlo cuanto antes: los problemas de suscripción o permisos son los más lentos de resolver.

### 0.1 Suscripción de Azure

- [ ] Tienes una suscripción activa (Azure for Students o similar): <https://portal.azure.com> → **Subscriptions** → estado *Active*.
- [ ] Tu rol en la suscripción es **Owner** (Subscriptions → tu suscripción → Access control (IAM) → View my access).
- [ ] Puedes registrar aplicaciones en Microsoft Entra ID: **Microsoft Entra ID → User settings → «Users can register applications»: Yes**, o eres administradora del directorio. Si es *No* (habitual en tenants universitarios), lee el error **CD-02** en `documentacion/05-solucion-errores.md` antes de seguir.

### 0.2 Crear el App Service

**Opción A — script (recomendada, reproducible):** con Azure CLI (`az --version`) instalado:

```bash
az login
# Elige un nombre ÚNICO en todo Azure (minúsculas, números y guiones). Ejemplo: ponderix-equipo7
./scripts/crear-recursos-azure.sh ponderix-<sufijo> brazilsouth F1        # Git Bash / Linux / macOS
# PowerShell:
# .\scripts\crear-recursos-azure.ps1 -AppName ponderix-<sufijo> -Location brazilsouth -Sku F1
```

(El script está en `paquetes/04-marbel/scripts/` del respaldo; ejecútalo desde ahí o desde tu rama.)

Si la región da error de política o de cuota, prueba otra (otra de las permitidas por la política de la suscripción) — ver CD-04.

**Opción B — portal:**

1. **Create a resource → Web App**.
2. **Basics:** Suscripción · **Resource group:** *Create new* `rg-ponderix` · **Name:** `ponderix-<sufijo>` · **Publish:** Code · **Runtime stack:** **.NET 10 (LTS)** · **Operating System:** **Linux** · **Region:** p. ej. Brazil South (en Azure for Students solo se permiten algunas regiones: brazilsouth, canadacentral, chilecentral, francecentral, spaincentral; compruébalo con `az policy assignment list`) · **Pricing plan:** *Create new* `asp-ponderix` → **Free F1** (o Basic B1 si hay crédito: arranque más rápido y *Always On*).
3. **Deployment:** **Continuous deployment: Disable** ⚠️ (si lo activas, Azure crea un workflow de GitHub Actions en el repo, que **no** es nuestra CD). **Basic authentication: Disable**.
4. **Review + create → Create**.
5. En la Web App: **Settings → Configuration → General settings**: **Startup Command** `dotnet Ponderix.Api.dll` · **HTTPS Only: On** · **Minimum TLS: 1.2** · **FTP state: Disabled** → **Save**.
6. **Monitoring → Health check → Enable** → ruta `/health` → **Save** (si el plan F1 no lo permite, no pasa nada: la CD valida `/health`).

Abre la URL `https://ponderix-<sufijo>.azurewebsites.net`: verás la página por defecto de App Service (todavía no hay despliegue).
📸 `evidencias/03-cd/01-app-service-overview.png` y `02-app-service-configuracion.png` (oculta el *Subscription ID* si aparece completo).

### 0.3 Service Connection (Azure DevOps → Azure), sin secretos en el repo

Necesitas ser **Project Administrator** en `Ponderix` (Jhon te añadió).

1. Azure DevOps → proyecto `Ponderix` → **Project settings → Service connections → New service connection → Azure Resource Manager → Next**.
2. **Identity type:** *App registration (automatic)* · **Credential:** *Workload identity federation*.
3. **Scope level:** Subscription → tu suscripción → **Resource group:** `rg-ponderix`.
4. **Service Connection Name:** `sc-azure-ponderix`.
5. **Security:** deja **sin marcar** «Grant access permission to all pipelines» (la CD pedirá permiso explícito en su primera ejecución).
6. **Save**. Si falla con un error de Entra ID / app registration → error **CD-02**.

📸 `evidencias/03-cd/03-service-connection.png` (sin mostrar IDs completos).

### 0.4 Entorno de despliegue

**Pipelines → Environments → New environment** → **Name:** `ponderix-produccion` · **Resource:** None → **Create**.

**Aprobaciones:** *no* agregues aprobación manual. Así, un cambio en `main` llega a Azure sin intervención humana (automatización extremo a extremo de la rúbrica). Explica en el video y la memoria que, si se añadiera *Approvals and checks → Approvals*, la CD quedaría en pausa «Waiting for approval» hasta que la persona aprobadora acepte: más control, menos automatización.

## 1. Qué debes esperar antes de crear la CD

- [ ] Jhon te entregó: pipeline **`ponderix-ci`**, artefacto **`webapp`**, al menos una ejecución exitosa en `main`.
- [ ] App Service creado y Service Connection `sc-azure-ponderix` verificada.
- [ ] Entorno `ponderix-produccion` creado.

## 2. Material que tomas del repositorio de respaldo

`paquetes/04-marbel/`:

| Archivo | Para qué |
|---|---|
| `pipelines/azure-pipelines-cd.yml` | Pipeline de CD completa (recurso de pipeline, despliegue y prueba de humo) |
| `scripts/crear-recursos-azure.sh` / `.ps1` | Creación reproducible del App Service con Azure CLI |

Cómo funciona `azure-pipelines-cd.yml`:

| Parte | Qué hace |
|---|---|
| `trigger: none`, `pr: none` | La CD **no** reacciona a commits ni PR… |
| `resources.pipelines` → `pipeline: ci`, `source: ponderix-ci`, `trigger: main` | …sino a la **finalización exitosa** de `ponderix-ci` en `main` |
| `deployment` + `environment: ponderix-produccion` | Registra cada despliegue en el historial del entorno |
| `download: ci` / `artifact: webapp` | Descarga el artefacto **de la ejecución de CI que la disparó** |
| Paso «Trazabilidad» | Renombra la ejecución a «CD de CI <build>» e imprime ejecución, rama y commit de origen |
| `AzureWebApp@1` | Despliega `$(Pipeline.Workspace)/ci/webapp/*.zip` con la Service Connection (Linux, `DOTNETCORE|10.0`) |
| Prueba de humo | Hasta 5 min: `/health` = `Healthy` **y** `/api/version.commit` = commit de la CI. Si no, la CD falla |

## 3. Rama, configuración y commits

```bash
git switch main
git pull origin main
git switch -c feature/marbel-pipeline-cd
mkdir -p pipelines scripts
cp /c/respaldo-ponderix/paquetes/04-marbel/pipelines/azure-pipelines-cd.yml pipelines/
cp /c/respaldo-ponderix/paquetes/04-marbel/scripts/crear-recursos-azure.* scripts/
git status       # solo archivos nuevos: pipelines/azure-pipelines-cd.yml y scripts/crear-recursos-azure.*
```

**Commit 1 — scripts de Azure:**

```bash
git add scripts/crear-recursos-azure.sh scripts/crear-recursos-azure.ps1
git commit -m "chore(azure): agregar scripts de creación del App Service Linux .NET 10"
```

**Configura los 3 valores marcados `[CONFIGURAR]`** en `pipelines/azure-pipelines-cd.yml` (no son secretos):

```yaml
      source: ponderix-ci                 # nombre exacto de la pipeline de Jhon
  azureServiceConnection: 'sc-azure-ponderix'
  webAppName: 'ponderix-<sufijo>'         # el nombre REAL de tu App Service
```

**Commit 2 — pipeline de CD:**

```bash
git add pipelines/azure-pipelines-cd.yml
git commit -m "cd: agregar pipeline de CD que despliega el artefacto webapp de CI en App Service"
git push -u origin feature/marbel-pipeline-cd
```

## 4. Pull Request

- **Título:** `Pipeline de CD (ponderix-cd) hacia Azure App Service`.
- **Descripción:** recurso de pipeline `ci` → `ponderix-ci`, artefacto consumido, App Service y entorno, prueba de humo, sin secretos (Service Connection con federación).
- **Reviewer:** `Jhonzn` (comprueba que `source` y `artifact` coinciden con su CI).
- Merge con **Create a merge commit**. No borres la rama.

## 5. Crear la pipeline `ponderix-cd` y primer despliegue

1. **Pipelines → New pipeline → GitHub → `ponderix` → Existing Azure Pipelines YAML file** → **Branch:** `main` → **Path:** `/pipelines/azure-pipelines-cd.yml` → **Continue** → flecha junto a Run → **Save**.
2. **⋯ → Rename/move** → **`ponderix-cd`**.
3. **Primera ejecución (de autorización):** la ejecución de CI generada por tu merge terminó *antes* de que existiera `ponderix-cd`, así que esta vez se lanza a mano: **Run pipeline → Resources → ci →** elige la última ejecución de `ponderix-ci` en `main` → **Run**.
4. Aparecerá «This pipeline needs permission to access 2 resources» → **View → Permit** (Service Connection y entorno). Es la autorización explícita de seguridad.
5. Sigue la ejecución: descarga del artefacto → trazabilidad → despliegue → prueba de humo ✅.
6. Abre la URL pública: la aplicación muestra **Versión 1.0.0** y en el pie el build y commit de la CI. `/api/version` muestra el mismo commit.

📸 `evidencias/03-cd/05-pipeline-cd-recurso.png`, `06-despliegue-exitoso.png`, `07-prueba-humo.png`, `04-entorno-produccion.png`.

## 6. Demostrar que la CD ya es automática (PR 2)

```bash
git switch main
git pull origin main
git switch -c feature/marbel-documentacion-cd
```

Completa en `README.md` la sección 10 (tabla de configuración, enlaces a `ponderix-cd` y a un despliegue) y la sección 11 (URL pública). Luego:

```bash
git add README.md
git commit -m "docs(readme): documentar App Service, pipeline de CD y URL pública"
git push -u origin feature/marbel-documentacion-cd
```

PR (reviewer Jhon) → merge. Ahora debe ocurrir **sin tocar nada**: CI en `main` → al terminar, **`ponderix-cd` arranca sola** (motivo: *Resource trigger* / disparada por `ponderix-ci`) → despliega → prueba de humo con el nuevo commit. Esta es la primera prueba de automatización extremo a extremo.

## 7. No continúes hasta comprobar lo siguiente

- [ ] `ponderix-cd` tiene una ejecución **disparada automáticamente** por `ponderix-ci` (no manual).
- [ ] La ejecución se llama «CD de CI <build>» y el paso de trazabilidad muestra el commit correcto.
- [ ] El paso `AzureWebApp@1` y la prueba de humo están en verde.
- [ ] La URL pública responde, `/health` = `Healthy` y `/api/version` muestra el commit del último merge.
- [ ] El entorno `ponderix-produccion` muestra el historial de despliegues.
- [ ] No hay en el repo ningún perfil de publicación, contraseña ni ID secreto (`git grep -i password` vacío).

## 8. Al finalizar mi parte debo entregar

| Entregable | A quién |
|---|---|
| URL pública del App Service | **Marlon** (siguiente) y Juan (README) |
| Enlaces a `ponderix-cd` y a la ejecución automática exitosa | Marlon |
| Confirmación «la CD se dispara sola tras la CI» | Marlon |
| Capturas 01–07 de `evidencias/03-cd/` | Marlon |
| Problemas encontrados en Azure/CD | README sección 16 y memoria (David) |

## 9. Qué explicas en los videos

- **Video 1 (CI):** muestra el artefacto `webapp` y `buildinfo.json` y explica por qué es el contrato con la CD: un único paquete inmutable, identificado por el número de ejecución y el commit, que la CD despliega sin recompilar.
- **Video 2 (CD) — eres la protagonista técnica:** «Soy Marbel Juliana Mejía Bedoya, responsable de la CD y Azure». Muestra el App Service (Linux, .NET 10, HTTPS Only), la Service Connection (sin secretos), el entorno, el YAML de CD (recurso `ci`, `trigger: none`, `download`, `AzureWebApp@1`, prueba de humo) y la ejecución de CD del cambio v1.1.0: artefacto recibido, despliegue y prueba de humo. Explica la decisión de no usar aprobación manual.

## 10. Problemas frecuentes

`documentacion/05-solucion-errores.md` (CD-01 a CD-11): la CD no se dispara, error al crear la Service Connection, permisos pendientes, región/cuota, «Application Error», versión antigua tras desplegar, arranque en frío de F1.
