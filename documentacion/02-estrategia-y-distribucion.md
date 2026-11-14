# 2. Estrategia de ejecución, distribución del trabajo y dependencias

## 2.1 Decisión: ¿en qué orden se desarrollan CI y CD?

Se evaluaron tres organizaciones:

| Opción | Descripción | Veredicto |
|---|---|---|
| **A. «Toda la CI y luego toda la CD»** (5 personas en CI, luego otra vez desde Juan en CD) | Respeta dependencias, pero duplica la rotación: Juan, David y Jhon no tienen nada técnico que aportar a la CD en la segunda vuelta, y Marbel no podría preparar Azure hasta que todos terminaran la CI. Mínimo ~2 rondas completas de esperas. | ❌ Descartada: esperas innecesarias y trabajo artificial |
| **B. «Cada uno hace un trozo de CI y otro de CD en su turno»** | Rompe las dependencias técnicas: Juan no puede configurar CD sin artefacto ni App Service; los trozos quedarían sin probar y habría que rehacerlos. | ❌ Descartada: técnicamente incorrecta |
| **C. «Cadena de relevos por dependencia técnica + preparación en paralelo»** | El orden de integración en `main` sigue la cadena real **aplicación → pruebas → CI → CD → verificación E2E** (que coincide con el orden Juan → David → Jhon → Marbel → Marlon). Lo que **no** depende del eslabón anterior (cuentas, Azure DevOps, paralelismo, App Service, Service Connection, scripts, plantillas de evidencias) se adelanta en paralelo desde el día 1. | ✅ **Recomendada** |

**Por qué C es correcta:** la CI necesita una solución que compile y pruebas que ejecutar; la CD necesita el artefacto y su nombre exacto; la verificación final necesita la CD funcionando. Pero **crear recursos** (organización de Azure DevOps, App Service, Service Connection, entorno) no necesita código: si se hace en paralelo, cuando llega el turno de cada persona solo le queda conectar y probar. Así nadie espera a que «toda una actividad» termine, y cada relevo es corto (1–2 días).

Además, CI y CD se **evalúan por separado** pero se **demuestran juntas**: un único cambio (v1.1.0) recorre ambas pipelines y se graba una sola vez, editando dos videos.

## 2.2 Tabla de responsabilidades

| | 1 · Juan Sebastián | 2 · David | 3 · Jhon | 4 · Marbel | 5 · Marlon |
|---|---|---|---|---|---|
| **Responsabilidad** | Gestión de GitHub, aplicación base y README | Pruebas automatizadas + edición de la memoria PDF | Configuración de CI | Configuración de CD y Azure | Verificación E2E, seguridad, evidencias y videos |
| **Actividades** | Crear repo, proteger `main`, invitar a `oalarconpe` y al equipo, aplicación .NET 10, README, CONTRIBUTING, plantilla de PR, instalar GitHub App, check obligatorio | Proyecto xUnit (25 pruebas), registrarlo en la solución, documentar pruebas, revisar PR de Juan, consolidar y exportar la memoria | Org/proyecto Azure DevOps, paralelismo, pipeline `ponderix-ci`, validación de PR, artefacto `webapp`, insignia (cambio controlado) | App Service, Service Connection, entorno, pipeline `ponderix-cd`, autorizaciones, prueba de humo, documentación Azure | Scripts de verificación y de secretos, cambio visible v1.1.0, tabla de trazabilidad, capturas, sesión de grabación, revisión final y entrega |
| **Archivos** | `src/**`, `Ponderix.slnx`, `global.json`, `.gitignore`, `.gitattributes`, `.editorconfig`, `README.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `.github/`, `evidencias/README.md` | `tests/Ponderix.Tests/**`, `Ponderix.slnx` (registro), README §8 | `pipelines/azure-pipelines-ci.yml`, README §9 + insignia | `pipelines/azure-pipelines-cd.yml`, `scripts/crear-recursos-azure.*`, README §10–11 | `scripts/verificar-despliegue.*`, `scripts/buscar-secretos.*`, `AppInfo.cs`, `CHANGELOG.md`, `evidencias/**`, README §12, §14 |
| **Ramas** | `feature/juan-sebastian-base-aplicacion` | `feature/david-pruebas-automatizadas` | `feature/jhon-pipeline-ci`, `feature/jhon-insignia-ci` | `feature/marbel-pipeline-cd`, `feature/marbel-documentacion-cd` | `feature/marlon-verificacion`, `feature/marlon-version-1-1`, `feature/marlon-evidencias` |
| **Commits** | 1 inicial + 5 | 4 | 1 + 1 | 2 + 1 | 2 + 1 + 2 |
| **PR** | 1 | 1 | 2 | 2 | 3 |
| **Revisa su PR** | David | Juan | Marbel | Jhon | Marbel / Juan |
| **Revisa a** | David, Marlon (docs) | Juan | Marbel | Jhon, Marlon | — (valida todo) |
| **Espera antes de empezar** | Nada | PR de Juan fusionado | PR de David fusionado + paralelismo | CI con artefacto en `main` (+ Azure preparado) | CD automática funcionando |
| **Entrega al siguiente** | «`main` lista», URL del repo | «Solución con pruebas en `main`» | Nombre `ponderix-ci`, artefacto `webapp`, ruta del zip | URL pública, CD automática confirmada | Validación final, enlaces, PDF |
| **Demuestra su contribución con** | PR #1, regla de protección, Collaborators | PR, pestaña Tests de la CI | PR, ejecuciones de CI, artefacto | PR, ejecuciones de CD, App Service, entorno | PR, tabla de trazabilidad, capturas, videos |
| **Explica en los videos** | V1: repo, `main`, reglas, historial. V2: PR/commit del cambio | V1: pruebas local y en CI. V2: pruebas como condición de la CD | V1: YAML, trigger, etapas, artefacto. V2: CI que disparó la CD | V1: artefacto como contrato. V2: Azure, YAML CD, despliegue | V1: fusiona el cambio en vivo. V2: URL, `/api/version`, verificación |

**Equidad:** cada persona tiene una pieza **técnica** imprescindible del flujo (app, pruebas, CI, CD, verificación E2E) **y** una pieza **documental** (README, memoria, sección CI, sección CD, evidencias/videos), revisa el trabajo de otra persona y protagoniza un bloque de cada video.

## 2.3 Cronograma (hoy: vie 13-nov-2026 · entrega: lun 23-nov-2026 23:59)

| Fecha | Juan | David | Jhon | Marbel | Marlon |
|---|---|---|---|---|---|
| **Vie 13** | Crear repo, proteger `main`, invitar | Instalar .NET 10/Git, aceptar invitación | **Crear org/proyecto ADO, pedir paralelismo**, invitar usuarios | Verificar suscripción, rol Owner y permisos Entra | Instalar herramientas, leer guion y evidencias |
| **Sáb 14** | **PR #1** app base → merge | Revisar PR #1 | Esperar paralelismo; ver video 1 del docente | Ver videos 2–4 del docente | Probar scripts en local (respaldo) |
| **Dom 15** | Revisar PR de David | **PR #2** pruebas → merge | Preparar YAML localmente | **Crear App Service** + Service Connection + entorno | Capturas de repo, plantilla de evidencias |
| **Lun 16** | **Instalar GitHub App** | Captura de Tests en CI | **PR #3** CI → crear `ponderix-ci` → merge | Revisar PR #3 | — |
| **Mar 17** | **Check obligatorio** de CI | — | **PR #4** insignia (cambio controlado) | Revisar PR #4 | Capturas de CI |
| **Mié 18** | — | — | Revisar PR #5 | **PR #5** CD → merge → crear `ponderix-cd` → 1.ª ejecución | — |
| **Jue 19** | Actualizar README | — | Revisar PR #6 | **PR #6** docs CD → **CD automática** | **PR #7** scripts → merge; verificación v1.0.0 |
| **Vie 20** | **Sesión de grabación (todos)** — Marlon fusiona **PR #8 v1.1.0** en vivo | | | | |
| **Sáb 21** | Revisar PR #9 | Iniciar memoria PDF | Redactar problemas CI | Redactar problemas CD | Editar y publicar videos; **PR #9** evidencias |
| **Dom 22** | Revisión final README | **Exportar PDF** | Revisión rúbrica CI | Revisión rúbrica CD | Checklist final |
| **Lun 23** | | | | | **Entrega en Teams antes de 12:00** (colchón hasta 23:59) |

Los números de PR son orientativos (GitHub asigna el número real).

## 2.4 Dependencias entre integrantes

| Quién espera | A quién | Qué necesita exactamente | Por qué |
|---|---|---|---|
| David | Juan | PR #1 fusionado (solución y API en `main`) | Las pruebas referencian `Ponderix.Api` y `Program` |
| Juan (revisión) | David | Aprobación del PR #1 | `main` exige 1 aprobación |
| Jhon (crear pipeline) | Juan | Instalación de la GitHub App en el repo | Solo el propietario del repo puede autorizarla |
| Jhon (CI completa) | David | PR #2 fusionado | Sin pruebas, la etapa Validar no valida nada |
| Jhon (ejecutar) | Microsoft | Paralelismo concedido o agente autohospedado | Sin agente no se ejecuta ninguna pipeline |
| Juan (check obligatorio) | Jhon | Nombre del check de la CI | El check aparece tras la primera validación de PR |
| Marbel (Service Connection) | Jhon | Ser Project Administrator en `Ponderix` | Permiso para crear conexiones y entornos |
| Marbel (CD) | Jhon | `ponderix-ci` con artefacto `webapp` en `main` | La CD declara `source: ponderix-ci` y descarga `webapp` |
| Marlon (E2E) | Marbel | CD disparada automáticamente y URL pública | El cambio v1.1.0 debe llegar solo a Azure |
| David (PDF) | Todos | Apartados redactados y capturas reales | La memoria se compone con evidencias reales |
| Entrega | Marlon + David | Videos publicados, README sin pendientes, PDF | Entregables 1–4 |

**Tareas en paralelo (no bloquean):** creación de la organización y el proyecto de Azure DevOps, solicitud de paralelismo, App Service, Service Connection, entorno, scripts de Marlon en local, plantillas de evidencias y guiones de video, visionado de los videos del docente.

**Tareas estrictamente secuenciales:** PR #1 → PR #2 → PR #3 (CI) → PR #5 (CD) → PR #8 (cambio v1.1.0).

## 2.5 Plan de contingencia

| Riesgo | Señal | Acción |
|---|---|---|
| Paralelismo no concedido el lun 16 | Ejecuciones «queued» sin agente | Agente autohospedado en el PC de Jhon (CI-01) |
| Service Connection bloqueada por Entra | Error al crear la conexión | Plan B: perfil de publicación como *Secure File* (CD-02) |
| Un integrante se retrasa | No entrega en su fecha | Los demás no rehacen su trabajo: se mueve su fecha y se usa el colchón del sáb–dom; la responsabilidad no se reasigna sin dejarlo documentado |
| Falla la CI tras un merge | Ejecución roja en `main` | Ver `04-flujo-git.md` §4.6 (fix hacia adelante con PR) |
| La CD falla durante la grabación | Ejecución roja | Se pausa la grabación, se diagnostica (es evidencia válida de solución de errores) y se repite el cambio |
