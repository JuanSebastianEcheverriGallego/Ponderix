# 10. Auditoría técnica del material

Revisión realizada el 13-nov-2026 sobre el contenido de este repositorio de respaldo, como revisor independiente. Distingue tres niveles: **verificado** (se ejecutó), **revisado** (se leyó y contrastó, sin poder ejecutarlo aquí) y **pendiente de ejecución real** (solo puede comprobarse en las cuentas del equipo).

## 10.1 Verificado mediante ejecución (Windows 11, .NET SDK 10.0.400)

| Elemento | Prueba | Resultado |
|---|---|---|
| Compilación | `dotnet build Ponderix.slnx -c Release` con `TreatWarningsAsErrors` | 0 advertencias, 0 errores |
| Pruebas | `dotnet test` con `--logger trx` y `--collect "XPlat Code Coverage"` (mismos argumentos que la CI) | 25/25 superadas; `.trx` y `coverage.cobertura.xml` generados |
| Registro de pruebas en la solución | `dotnet sln Ponderix.slnx add tests/...` (paso manual de David) | `.slnx` con carpetas `/src/` y `/tests/` |
| Empaquetado | `dotnet publish` + `buildinfo.json` + zip | Zip de ~110 KB con `Ponderix.Api.dll` en la raíz |
| Fragmentos bash de la CI | Extraídos del YAML con un parser y ejecutados con variables simuladas | `buildinfo.json` es JSON válido con el commit; etiqueta `commit-<sha7>` correcta |
| Fragmentos bash de la CD | Paso de trazabilidad y prueba de humo extraídos del YAML | Éxito con commit correcto; **falla** con commit distinto y con app caída (comportamiento deseado) |
| Aplicación publicada | `scripts/verificar-despliegue.sh` y `.ps1` contra la app publicada en local | `/health`, versión/commit, cálculo 4.75, HTTP 400, página: todo OK |
| Búsqueda de secretos | `buscar-secretos.sh` y `.ps1` sobre el repo oficial ensamblado | Sin hallazgos; con un secreto y un `.env` plantados, ambos los **detectan** |
| Sintaxis YAML | `yaml.safe_load` de ambos pipelines | Válida |
| Runtime de Azure | `az webapp list-runtimes --os linux` | `DOTNETCORE|10.0` disponible |
| Ensamblado completo | `scripts/ensamblar-y-verificar.sh` (paquetes 1–5) | Termina en «verificación superada» |

## 10.2 Correcciones aplicadas durante la auditoría

| # | Hallazgo | Corrección |
|---|---|---|
| 1 | `UseHttpsRedirection` detrás del proxy de App Service genera avisos y no aporta (TLS termina en Azure) | Eliminado; HTTPS se fuerza con *HTTPS Only* del App Service |
| 2 | `verificar-despliegue.sh` dependía de `jq`/`python3`, ausentes en Git Bash de Windows (2 falsos fallos) | Lectura de JSON solo con `sed` |
| 3 | El script de ensamblado dejaba vivo el proceso `dotnet` en Windows (bloqueaba la carpeta) | Se lanza `dotnet` sin subshell para que el `trap` lo detenga |
| 4 | Patrón `\x27` no válido en ERE de `grep` en `buscar-secretos.sh` | Patrón simplificado (`Password=[^;" ]+`) |
| 5 | Comprobación del `.zip` en la CD con `$( … )` dentro del YAML (posible confusión con macros de Azure) | Reescrita con `ls … >/dev/null` |
| 6 | La guía de David afirmaba que fallaban 2 pruebas al cambiar el umbral 4.5 | Corregido: falla la prueba del límite 4.5 |
| 7 | Mensaje de `buscar-secretos` apuntaba a un documento que no existe en el repo oficial | Apunta a README §15, que ahora incluye el procedimiento |

## 10.3 Revisado (coherencia), no ejecutable aquí

| Aspecto | Comprobación |
|---|---|
| Nombres cruzados | `ponderix-ci` (CI) = `source:` (CD); artefacto `webapp` publicado = `download: ci / artifact: webapp`; ruta `$(Pipeline.Workspace)/ci/webapp/*.zip` |
| Rutas sensibles a mayúsculas (Linux) | `Ponderix.slnx`, `src/Ponderix.Api/Ponderix.Api.csproj`, `Ponderix.Api.dll` coinciden en YAML, scripts y comando de inicio |
| Runtime | `net10.0` ↔ `UseDotNet 10.0.x` ↔ `runtimeStack: DOTNETCORE|10.0` ↔ `--runtime DOTNETCORE:10.0` |
| Disparadores | CI: `trigger`/`pr` en `main`; Empaquetar excluida en PR. CD: `trigger: none`, `pr: none`, solo el recurso `ci` sobre `main` |
| Variables de recurso | `resources.pipeline.ci.{sourceCommit, runName, runID, sourceBranch, pipelineName}` y salida `AppServiceApplicationUrl` de `AzureWebApp@1` (referenciada como `despliegue.AppServiceApplicationUrl`) según la documentación de Azure Pipelines |
| Seguridad | Ningún secreto en archivos; solo nombres de recursos en YAML |
| Documentación | README, guías, matrices y guiones usan los mismos nombres, ramas, PR y fechas |

## 10.4 Pendiente de ejecución real (no se puede dar por cumplido)

Nada de lo siguiente se ha ejecutado, porque requiere las cuentas del equipo:

1. Creación del repositorio `PonderixOficial`, colaboradores (incluido `oalarconpe`) y protección de `main`.
2. Organización/proyecto de Azure DevOps, paralelismo, GitHub App, pipelines `ponderix-ci` y `ponderix-cd`.
3. Primera ejecución real de ambas pipelines en agentes de Microsoft (las tareas `UseDotNet@2`, `PublishTestResults@2`, `PublishCodeCoverageResults@2`, `ArchiveFiles@2`, `PublishPipelineArtifact@1` y `AzureWebApp@1` solo se validan de verdad ahí).
4. App Service, Service Connection, entorno y autorizaciones.
5. Cambio v1.1.0 de extremo a extremo, capturas, videos, memoria PDF y entrega.

## 10.5 Riesgos residuales

| Riesgo | Probabilidad | Mitigación preparada |
|---|---|---|
| Paralelismo no concedido a tiempo | Media | Solicitud el día 1; agente autohospedado (CI-01) |
| Entra ID bloquea la Service Connection automática | Media en tenants universitarios | Opciones de CD-02 y YAML alternativo de zip deploy |
| Cuota/arranque lento de F1 durante la grabación | Media | Escalar a B1 ese día (CD-08) |
| Cambios de interfaz de Azure DevOps/portal respecto a las guías | Baja–media | Los nombres de las opciones son estables; ante diferencias, buscar la opción equivalente y anotarlo en la memoria |
| Un integrante sin disponibilidad | Media | Cronograma con colchón sáb–dom; tareas paralelas adelantadas |
