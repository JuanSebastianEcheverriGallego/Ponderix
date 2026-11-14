# 5. Solución de errores frecuentes

Formato: **síntoma → causa probable → solución**. Si un error real ocurre, regístrenlo en README §16 y en la memoria (es evidencia de «capacidad de solucionar errores», que el docente valora expresamente).

## CI · Azure Pipelines

### CI-01 · «No hosted parallelism has been purchased or granted»
- **Causa:** organización nueva sin concesión gratuita de agentes hospedados.
- **Solución A:** solicitarla en <https://aka.ms/azpipelines-parallelism-request> (2–3 días hábiles).
- **Solución B (agente autohospedado en el PC de Jhon, Windows):**
  1. Azure DevOps → **User settings → Personal access tokens → New token** · ámbito *Agent Pools (Read & manage)* · caducidad 30 días. **Cópialo solo en el asistente; nunca lo guardes en el repo ni en el chat.**
  2. **Organization settings → Agent pools → Default → New agent → Windows → Download**; descomprime en `C:\agente`.
  3. En PowerShell: `cd C:\agente; .\config.cmd` → URL `https://dev.azure.com/<org>` → *PAT* → pool `Default` → nombre `pc-jhon` → *run as service: N*. Luego `.\run.cmd` (déjalo abierto mientras haya ejecuciones).
  4. Requisitos: Git for Windows con `C:\Program Files\Git\bin` en el PATH **antes** de `C:\Windows\System32` (para que los pasos `bash` no usen WSL).
  5. En **ambos** YAML cambia
     ```yaml
     pool:
       vmImage: ubuntu-latest
     ```
     por
     ```yaml
     pool:
       name: Default
     ```
     en un PR `fix(ci): usar agente autohospedado mientras se concede el paralelismo`. Revoca el PAT al terminar la práctica.

### CI-02 · El repositorio no aparece al crear la pipeline
- **Causa:** la GitHub App *Azure Pipelines* no está instalada en el repo, o la instaló alguien sin ser propietario.
- **Solución:** Juan (propietario) → <https://github.com/apps/azure-pipelines> → Configure → *Only select repositories* → `ponderix` → elegir organización/proyecto `Ponderix`.

### CI-03 · El merge en `main` no lanza la CI
- **Causas:** (1) en *Edit → ⋯ → Triggers* alguien marcó «Override the YAML continuous integration trigger»; (2) el YAML aún no está en `main`; (3) la ruta del YAML en la pipeline no es `/pipelines/azure-pipelines-ci.yml`; (4) el webhook de GitHub falló.
- **Solución:** desmarcar el *override*; comprobar `git ls-files pipelines/` en `main`; en GitHub → Settings → GitHub Apps → Azure Pipelines → revisar acceso al repo. Hacer un nuevo cambio controlado (no lanzar manualmente para la evidencia).

### CI-04 · `NETSDK1045` o «A compatible .NET SDK was not found»
- **Causa:** el agente usa un SDK anterior a .NET 10 o `UseDotNet@2` no se ejecutó primero.
- **Solución:** `UseDotNet@2` con `version: 10.0.x` debe ser el primer paso de cada job (ya lo es). No cambiar `global.json` a una versión exacta inexistente.

### CI-05 · `MSB1009: Project file does not exist`
- **Causa:** Linux distingue mayúsculas: `ponderix.slnx` ≠ `Ponderix.slnx`; o la ruta del proyecto cambió.
- **Solución:** respetar exactamente `Ponderix.slnx` y `src/Ponderix.Api/Ponderix.Api.csproj`.

### CI-06 · «No test result files matching … were found»
- **Causa:** las pruebas no están en la solución, o el `--results-directory` cambió.
- **Solución:** `dotnet sln Ponderix.slnx list` debe mostrar `tests/Ponderix.Tests`; no cambiar `$(Agent.TempDirectory)/TestResults`.

### CI-07 · La etapa Validar falla en «Ejecutar pruebas»
- **Causa:** una prueba detecta un error real (comportamiento deseado).
- **Solución:** pestaña **Tests** → prueba fallida → mensaje; reproducir con `dotnet test`; corregir por PR. No desactivar pruebas para «pasar».

### CI-08 · En `main`, la etapa Empaquetar aparece «Skipped»
- **Causa:** la etapa Validar falló, o la ejecución es de un PR (`Build.Reason = PullRequest`), que es lo esperado.
- **Solución:** si es de `main`, corregir primero Validar.

### CI-09 · El artefacto no contiene `.zip` o el zip contiene una carpeta `publish/`
- **Causa:** se modificaron `includeRootFolder` o `targetPath`.
- **Solución:** `includeRootFolder: false` y `targetPath: $(Build.ArtifactStagingDirectory)/webapp` (como en el YAML entregado).

### CI-10 · El check de CI no aparece para marcarlo obligatorio en GitHub
- **Causa:** GitHub solo lista checks que se ejecutaron en los últimos 7 días.
- **Solución:** abrir un PR (el de la insignia sirve) y luego buscar el check en la regla.

## CD · Azure Pipelines y Azure App Service

### CD-01 · La CD no se dispara al terminar la CI
- **Causas y soluciones:**
  1. `source:` no coincide con el nombre real de la pipeline de CI → renombrar la CI a `ponderix-ci` o corregir `source`.
  2. El YAML de CD no está en la rama por defecto (`main`).
  3. La CI terminó en una rama distinta de `main` o era una validación de PR (filtrada a propósito).
  4. La CI terminó **antes** de crear `ponderix-cd` → ejecutar la CD una vez a mano y hacer un nuevo cambio.
  5. La CI falló o terminó *partially succeeded*.
  6. La CD está esperando permisos (CD-03).

### CD-02 · Error al crear la Service Connection («insufficient privileges», «failed to create app registration»)
- **Causa:** el tenant (frecuente en cuentas universitarias) no permite registrar aplicaciones o no eres Owner de la suscripción.
- **Soluciones en orden de preferencia:**
  1. Pedir al administrador del tenant que cree la conexión o habilite el registro de apps.
  2. Usar una suscripción en un tenant propio (p. ej., Azure for Students activado con una cuenta Microsoft personal, donde eres administradora).
  3. **Plan B documentado:** despliegue por *zip deploy* con credenciales de publicación guardadas como **variables secretas** de Azure DevOps (nunca en el repo): `documentacion/alternativas/azure-pipelines-cd-zipdeploy.yml`. Requiere activar *SCM Basic Auth Publishing Credentials* en el App Service. Explicar en la memoria por qué se usó y que es menos seguro que la federación.

### CD-03 · La CD queda en «Waiting: This pipeline needs permission to access a resource»
- **Causa:** Service Connection y entorno se crearon sin «acceso a todas las pipelines» (decisión de seguridad).
- **Solución:** abrir la ejecución → **View → Permit** para cada recurso (una sola vez).

### CD-04 · `RequestDisallowedByPolicy`/`RequestDisallowedByAzure` o límite de planes F1 al crear el App Service
- **Causa:** la suscripción de estudiante solo permite ciertas regiones, o ya existe un plan Free Linux en esa región.
- **Solución:** probar `eastus`, `eastus2`, `westus2`, `centralus`, `brazilsouth`; reutilizar el plan existente; o usar B1 si hay crédito.

### CD-05 · La URL muestra «Application Error» o HTTP 503 después de desplegar
- **Causas:** comando de inicio incorrecto (`dotnet Ponderix.Api.dll`), pila distinta de `DOTNETCORE|10.0`, o el zip tenía una carpeta raíz.
- **Diagnóstico:** App Service → **Log stream**, o `az webapp log tail -g rg-ponderix -n <app>`; **Diagnose and solve problems → Application Logs**.
- **Solución:** corregir *Startup Command* y pila; confirmar `includeRootFolder: false`.

### CD-06 · `AzureWebApp@1`: «Resource … not found» o «AuthorizationFailed»
- **Causa:** `webAppName` mal escrito, o la Service Connection tiene ámbito en otro grupo de recursos.
- **Solución:** `az webapp list -o table`; editar la conexión con ámbito `rg-ponderix`.

### CD-07 · El despliegue termina en verde pero la app muestra la versión anterior
- **Causa:** caché del navegador o la app aún no reinició.
- **Solución:** la prueba de humo ya espera hasta que `/api/version` devuelva el commit nuevo (si no, falla). En el navegador: Ctrl+F5.

### CD-08 · La prueba de humo agota los 5 minutos / HTTP 403 «Site quota exceeded»
- **Causa:** plan F1: arranque en frío lento o agotada la cuota diaria de 60 min de CPU.
- **Solución:** reintentar la ejecución (**Rerun failed jobs**); si es cuota, esperar al reinicio diario o escalar temporalmente a B1 (`az appservice plan update -g rg-ponderix -n asp-ponderix --sku B1`). Para la grabación, conviene B1 durante ese día y volver a F1 después.

### CD-09 · «Environment ponderix-produccion could not be found» o sin permiso
- **Solución:** crear el entorno (guía 4 §0.4) y, en *Security* del entorno, dar a la pipeline permiso o pulsar *Permit* en la ejecución.

### CD-10 · Aparece un archivo `.github/workflows/*.yml` en el repo creado por Azure
- **Causa:** se activó *Continuous deployment* / *Deployment Center* con GitHub Actions en el portal.
- **Solución:** App Service → **Deployment Center → Disconnect**; eliminar el workflow mediante un PR `chore: eliminar workflow creado por Deployment Center`. Nuestra CD es Azure DevOps.

### CD-11 · «No package found with specified pattern: …/ci/webapp/*.zip»
- **Causa:** el alias del recurso no es `ci`, el artefacto no se llama `webapp`, o la CI se ejecutó para un PR (sin artefacto).
- **Solución:** revisar el paso de trazabilidad (lista el contenido descargado) y alinear nombres con Jhon.

## GitHub

| Síntoma | Solución |
|---|---|
| «Merging is blocked: review required» | Pedir la aprobación al revisor asignado |
| «Required status check is expected» | Esperar a que la CI termine; si nunca empieza, ver CI-03 |
| `! [rejected] main -> main (protected branch)` | Correcto: no se sube a `main` directo; usar rama + PR |
| `Updates were rejected because the remote contains work…` | `git pull --rebase origin <tu-rama>` y repetir el push |
