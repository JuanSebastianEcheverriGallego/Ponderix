# 3. Guía maestra de ejecución (de cero a la entrega)

Esta guía da la visión cronológica completa. El detalle de cada clic y comando está en la guía individual indicada en cada fase (`guias_integrantes/0N-*.md`). Ninguna fase se marca como terminada hasta cumplir su **condición para avanzar**.

Leyenda de responsables: **J** Juan Sebastián · **D** David · **Jh** Jhon · **M** Marbel · **Ma** Marlon.

---

## Fase 1 · Preparación de los repositorios

| | |
|---|---|
| **Responsable** | J (principal) · todos (respaldo) |
| **Requisitos previos** | Cuentas de GitHub de los 5; Git y .NET SDK 10 instalados |
| **Acciones** | 1) Subir el repositorio de respaldo a GitHub como `ponderix-respaldo` (privado, opcional; ver §Respaldo al final). 2) J crea el repo oficial **`ponderix`** vacío y público. 3) Primer commit en `main` (`.gitignore`, `.gitattributes`, README mínimo). |
| **Comandos** | Guía 1 §2–3 |
| **Archivos** | `.gitignore`, `.gitattributes`, `README.md` |
| **Resultado esperado** | `https://github.com/JuanSebastianEcheverriGallego/ponderix` con rama `main` |
| **Evidencia** | `evidencias/01-repositorio/01-repositorio-nombre-y-main.png` |
| **Condición para avanzar** | La rama por defecto es `main` y el repo tiene nombre distintivo |

## Fase 2 · Selección y preparación de la aplicación

| | |
|---|---|
| **Responsable** | J |
| **Decisión** | No existía una aplicación previa en el material recibido, así que se creó **Ponderix**: API Minimal + interfaz web en **.NET 10 LTS** (la tecnología de los videos del docente; .NET 8 dejó de tener soporte el 10-nov-2026). Sin base de datos ni servicios externos: nada que configurar o proteger aparte del despliegue. Funcionalidad real (cálculo ponderado con validaciones) + `/health` + `/api/version` para trazabilidad. |
| **Acciones** | Copiar `paquetes/01-juan-sebastian/`, 5 commits, ejecutar en local, PR #1 |
| **Resultado esperado** | `dotnet build` 0 advertencias; <http://localhost:5080> funciona |
| **Evidencia** | PR #1 fusionado |
| **Condición para avanzar** | PR #1 fusionado con merge commit |

## Fase 3 · Configuración inicial de GitHub

| | |
|---|---|
| **Responsable** | J |
| **Acciones** | Regla `proteccion-main` (PR + 1 aprobación, sin force push ni borrado); invitar por **usuario** a `Davdfranco`, `Jhonzn`, `JULIANA-s22`, `M3rl0n`, **`oalarconpe`**; activar *Secret scanning* y *Push protection* |
| **Resultado esperado** | Collaborators muestra a los 5; `oalarconpe` aceptado o pendiente |
| **Evidencia** | `01-repositorio/02-colaboradores-oalarconpe.png`, `03-proteccion-main.png` |
| **Condición para avanzar** | Los 4 integrantes aceptaron (sin eso no pueden crear ramas ni aprobar) |

## Fase 4 · Distribución de responsabilidades

| | |
|---|---|
| **Responsable** | Todos (reunión de 20 min el vie 13) |
| **Acciones** | Leer `02-estrategia-y-distribucion.md`; cada uno confirma su guía, fechas y a quién revisa; crear chat del equipo; compartir cuentas Microsoft para Azure DevOps |
| **Resultado esperado** | Tabla de responsabilidades aceptada; fechas en el calendario |
| **Condición para avanzar** | Cada persona sabe qué espera y qué entrega |

## Fase 5 · Configuración de Azure DevOps

| | |
|---|---|
| **Responsable** | Jh (desde el día 1, en paralelo) |
| **Acciones** | Organización (o reutilizar), *Allow public projects*, proyecto **`Ponderix`** público, usuarios Basic (M como Project Administrator), **verificar/solicitar paralelismo** |
| **Pasos de interfaz** | Guía 3 §0 |
| **Resultado esperado** | Los 5 acceden al proyecto; Parallel jobs ≥ 1 (o agente autohospedado registrado) |
| **Evidencia** | Captura de Parallel jobs (memoria) |
| **Condición para avanzar** | Hay capacidad de ejecución |

## Fase 6 · Configuración de la CI

| | |
|---|---|
| **Responsable** | D (pruebas) → Jh (pipeline) · J (GitHub App) |
| **Requisitos previos** | PR #1 y PR #2 fusionados; fase 5 completa |
| **Acciones** | D: PR #2 con 25 pruebas. Jh: rama con `pipelines/azure-pipelines-ci.yml` → New pipeline → GitHub → J instala la GitHub App → *Existing YAML* → **Save** → renombrar a **`ponderix-ci`** → PR #3 |
| **Archivos** | `tests/Ponderix.Tests/**`, `pipelines/azure-pipelines-ci.yml` |
| **Resultado esperado** | El PR #3 muestra el check de la CI (solo Validar) |
| **Evidencia** | `02-ci/01`, `03`, `04`, `08` |
| **Condición para avanzar** | Validación de PR en verde y PR #3 aprobado por M |

## Fase 7 · Validación de la CI

| | |
|---|---|
| **Responsable** | Jh · J (check obligatorio) |
| **Acciones** | Fusionar PR #3 → comprobar ejecución automática en `main` (motivo *Individual CI*, mismo SHA). J añade el check como obligatorio. Jh hace el PR #4 (insignia) como **cambio controlado** y comprueba una segunda ejecución automática |
| **Resultado esperado** | Dos ejecuciones automáticas en `main`, etapas Validar y Empaquetar en verde, 25/25 pruebas |
| **Evidencia** | `02-ci/02`, `05`, `06` |
| **Condición para avanzar** | Ninguna ejecución de `main` fue lanzada manualmente |

## Fase 8 · Publicación y comprobación del artefacto

| | |
|---|---|
| **Responsable** | Jh (verifica) · M (valida que le sirve) |
| **Acciones** | Abrir el artefacto `webapp`; descargar `buildinfo.json`; comparar `commit` con el SHA de GitHub; confirmar un único `ponderix-<build>.zip` |
| **Resultado esperado** | `buildinfo.json` = `{ build: <número de ejecución>, commit: <SHA de main>, rama: main, … }` |
| **Evidencia** | `02-ci/07-artefacto-webapp.png` |
| **Condición para avanzar** | Jh entrega a M: `ponderix-ci`, `webapp`, `$(Pipeline.Workspace)/ci/webapp/*.zip` |

## Fase 9 · Preparación de Azure App Service

| | |
|---|---|
| **Responsable** | M (en paralelo desde el dom 15) |
| **Acciones** | `scripts/crear-recursos-azure.sh ponderix-<sufijo> brazilsouth F1` (o portal): RG `rg-ponderix`, plan Linux `asp-ponderix`, Web App .NET 10, comando de inicio, HTTPS Only, TLS 1.2, FTP deshabilitado, health check `/health`, **sin** «Continuous deployment» del portal |
| **Resultado esperado** | La URL muestra la página por defecto de App Service |
| **Evidencia** | `03-cd/01`, `02` |
| **Condición para avanzar** | Web App en estado *Running* |

## Fase 10 · Configuración de la CD

| | |
|---|---|
| **Responsable** | M |
| **Acciones** | Service Connection **`sc-azure-ponderix`** (ARM, federación, ámbito `rg-ponderix`, sin acceso a todas las pipelines); entorno **`ponderix-produccion`** sin aprobaciones; rama con `pipelines/azure-pipelines-cd.yml` ajustando los 3 valores `[CONFIGURAR]`; PR #5 (revisa Jh) |
| **Resultado esperado** | PR #5 fusionado |
| **Evidencia** | `03-cd/03`, `04` |
| **Condición para avanzar** | YAML en `main` con `source: ponderix-ci`, `webAppName` real y Service Connection correcta |

## Fase 11 · Vinculación CI → CD

| | |
|---|---|
| **Responsable** | M |
| **Acciones** | Crear pipeline desde `main` → **Save** → renombrar **`ponderix-cd`** → 1.ª ejecución manual eligiendo la última CI → **Permit** recursos → despliegue v1.0.0. Luego PR #6 (docs CD): su merge debe disparar CI y, al terminar, **la CD sola** |
| **Resultado esperado** | Ejecución «CD de CI <build>» con motivo de recurso (no manual); prueba de humo verde |
| **Evidencia** | `03-cd/05`, `06`, `07` |
| **Condición para avanzar** | Hay al menos una CD disparada automáticamente y la URL muestra 1.0.0 |

## Fase 12 · Prueba completa de extremo a extremo

| | |
|---|---|
| **Responsable** | Ma (con todos, en la sesión de grabación) |
| **Acciones** | PR #7 (scripts) previo. Captura «antes» (1.0.0). PR #8: `AppInfo.cs` 1.0.0 → 1.1.0 + CHANGELOG → merge **en vivo** → CI automática → artefacto → CD automática → URL con 1.1.0 → `verificar-despliegue` |
| **Resultado esperado** | El mismo SHA en GitHub, CI, `buildinfo.json`, CD y `/api/version` |
| **Evidencia** | `04-extremo-a-extremo/01`–`08` y tabla de trazabilidad |
| **Condición para avanzar** | `verificar-despliegue` → «verificación superada» |

## Fase 13 · Generación de evidencias

| | |
|---|---|
| **Responsable** | Ma (coordina) · cada responsable aporta sus capturas |
| **Acciones** | Completar todas las capturas listadas en `evidencias/README.md` y la matriz `08-matriz-evidencias.md`; `buscar-secretos` sin hallazgos; PR #9 con capturas y README final |
| **Resultado esperado** | `git grep PENDIENTE` vacío; capturas legibles sin datos sensibles |
| **Condición para avanzar** | PR #9 fusionado |

## Fase 14 · Grabación de los videos

| | |
|---|---|
| **Responsable** | Ma (moderador) · todos |
| **Acciones** | Seguir `videos/guion-video-1-ci.md` y `videos/guion-video-2-cd.md`; toma continua del cambio v1.1.0; editar en dos videos; subir a YouTube como **No listado** |
| **Resultado esperado** | 2 videos (≈ 8–12 min cada uno) donde los 5 se presentan y explican su parte con pantallas reales |
| **Condición para avanzar** | Los enlaces abren en ventana privada |

## Fase 15 · Elaboración del documento PDF

| | |
|---|---|
| **Responsable** | D (editor) · todos redactan sus apartados |
| **Acciones** | Plantilla `07-memoria-tecnica.md` → documento compartido → capturas reales → exportar `Ponderix-Memoria-Tecnica-CICD.pdf` |
| **Condición para avanzar** | Sin marcadores pendientes; enlaces clicables |

## Fase 16 · Revisión final de rúbricas

| | |
|---|---|
| **Responsable** | Jh (rúbrica CI) · M (rúbrica CD) · Ma (consolida) |
| **Acciones** | Recorrer `09-matriz-rubricas.md` y marcar «Cumplido» **solo** con la evidencia delante; corregir lo que falte |
| **Condición para avanzar** | Todos los criterios con evidencia enlazada |

## Fase 17 · Entrega en Microsoft Teams

| | |
|---|---|
| **Responsable** | Ma (con D) |
| **Acciones** | `entregables/checklist-entrega-teams.md`: enlace al repo, enlace Video CI, enlace Video CD, PDF; comprobar acceso de `oalarconpe`; **Entregar** antes del lun 23-nov 12:00 |
| **Resultado esperado** | Tarea en estado «Entregado» |

---

## Anexo · Cómo publicar el repositorio de respaldo

Desde la carpeta del respaldo (la que contiene `paquetes/`, `guias_integrantes/`, …):

```bash
git init -b main
git add .
git commit -m "chore: material de preparación de la práctica final CI/CD"
# Crear en GitHub un repo PRIVADO vacío llamado ponderix-respaldo e invitar al equipo
git remote add origin https://github.com/<propietario>/ponderix-respaldo.git
git push -u origin main
```

El respaldo **no se entrega** al docente ni sustituye al repo oficial: el trabajo evaluable son los commits y PR de cada integrante en `ponderix`.
