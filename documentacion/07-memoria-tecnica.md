# Memoria técnica · Plantilla del documento PDF

**Editor:** David · **Archivo final:** `Ponderix-Memoria-Tecnica-CICD.pdf` · **Extensión orientativa:** 20–30 páginas con capturas.

Instrucciones de uso:
- Copiar esta estructura a Word/Google Docs (o exportar este Markdown con la extensión «Markdown PDF» de VS Code / `pandoc`).
- Cada apartado indica **quién redacta** y las **capturas reales** que se insertan, desde `evidencias/`.
- Cada captura lleva pie de figura: «Figura N. Qué muestra — qué demuestra».
- Los textos marcados como *borrador* ya describen el diseño; revísenlos y adáptenlos a lo que realmente ocurrió. Todo lo que diga «[INSERTAR]» o «[PENDIENTE]» debe sustituirse por datos reales.
- **No** incluir capturas ilustrativas ni simuladas: si algo no se ejecutó, no se afirma.

---

## 1. Portada · *Juan*
- Universidad, asignatura «Despliegue de Software · 2026-2 · A distancia», «Práctica final · CI + CD».
- Proyecto **Ponderix** · Equipo Ponderix · nombres completos de los 5 integrantes · docente · fecha de entrega.
- Enlaces: repositorio, URL pública, Video 1, Video 2.

## 2. Información de la práctica · *Juan*
Objetivo del PDF del docente (flujo Código → CI → Artefacto → CD → Azure), ponderación 50/50, fecha límite.

## 3. Nombre del proyecto · *Juan*
Por qué «Ponderix» (calculadora de notas ponderadas, distintivo y relacionado con la propia rúbrica).

## 4. Integrantes y responsabilidades · *Juan*
Tabla de `02-estrategia-y-distribucion.md` §2.2 con **enlaces reales a los PR** de cada persona.
📸 `05-equipo/01-insights-contributors.png`, `01-repositorio/05-pull-requests-cerrados.png`.

## 5. Objetivo · *Juan*
*Borrador:* «Implementar y demostrar un flujo automatizado en el que cada cambio aprobado en la rama `main` de GitHub se valida y empaqueta en Azure Pipelines (CI) y se publica automáticamente en Azure App Service (CD), con trazabilidad del commit hasta la versión publicada.»

## 6. Tecnologías utilizadas · *Juan*
Tabla del README §3 y justificación: .NET 10 LTS (soporte hasta nov-2028; .NET 8 terminó su soporte el 10-nov-2026), Minimal API (poco código, foco en CI/CD), xUnit, Azure Pipelines YAML (versionado con el código), App Service Linux (PaaS, sin gestionar servidores).

## 7. Descripción de la aplicación · *Juan*
Endpoints (README §2) y una captura de la interfaz funcionando en local.
📸 Captura local de <http://localhost:5080> con un cálculo.

## 8. Arquitectura general · *Juan*
Diagrama del flujo (README §4; se puede exportar el diagrama mermaid como imagen) y descripción de componentes: GitHub, Azure DevOps (`ponderix-ci`, `ponderix-cd`, entorno, Service Connection), Azure (`rg-ponderix`, `asp-ponderix`, Web App).

## 9. Desarrollo de CI · *Jhon*
Decisiones: disparador en `main` + validación de PR; dos etapas; artefacto solo desde `main`; comandos `dotnet` reproducibles; número de ejecución `yyyyMMdd.r`; `buildinfo.json`.

## 10. Configuración de la pipeline CI · *Jhon*
Fragmentos comentados del YAML (trigger/pr, etapas, condición de Empaquetar, publicación del artefacto). Organización/proyecto, conexión con GitHub, paralelismo (y si se solicitó o se usó agente propio).
📸 `02-ci/03-conexion-github.png`, `02-ci/04-pipeline-ci-yaml.png`.

## 11. Explicación de las etapas de CI · *Jhon* (pruebas: *David*)
Tabla paso a paso: SDK → restore → build → test (25 pruebas: 19 unitarias, 6 de integración) → resultados/cobertura → publish → buildinfo → zip → artefacto → etiqueta.
📸 `02-ci/06-etapas-ci.png`, `02-ci/02-pruebas-en-pipeline.png`, `02-ci/01-pruebas-locales.png`.

## 12. Ejecución y validación de CI · *Jhon*
Ejecución automática por merge del PR de la CI y por el cambio controlado (insignia): motivo, SHA, duración. Validación de PR (Empaquetar *Skipped*).
📸 `02-ci/05-disparador-automatico.png`, `02-ci/08-validacion-pr.png`.

## 13. Artefacto generado · *Jhon*
Nombre `webapp`, contenido (`ponderix-<build>.zip`, `buildinfo.json`), cómo se relaciona con el commit, dónde lo consume la CD.
📸 `02-ci/07-artefacto-webapp.png` + contenido de `buildinfo.json`.

## 14. Desarrollo de CD · *Marbel*
Decisión: pipeline YAML independiente con **recurso de pipeline** (equivalente a la *Release* clásica de los videos del docente, pero versionada); sin aprobación manual (y efecto que tendría añadirla); prueba de humo que compara commits.

## 15. Configuración de Azure App Service · *Marbel*
Tabla README §10 (sin IDs) y cómo se creó (script o portal). Por qué *Continuous deployment* del portal se dejó deshabilitado.
📸 `03-cd/01-app-service-overview.png`, `03-cd/02-app-service-configuracion.png`.

## 16. Configuración de la pipeline CD · *Marbel*
Fragmentos comentados del YAML; Service Connection (federación, ámbito RG, sin acceso global); entorno `ponderix-produccion`; autorización inicial (*Permit*).
📸 `03-cd/03-service-connection.png`, `03-cd/04-entorno-produccion.png`.

## 17. Consumo del artefacto de CI · *Marbel*
`download: ci` → `$(Pipeline.Workspace)/ci/webapp/*.zip`; paso de trazabilidad que imprime ejecución y commit de origen; **no** hay `dotnet build` en la CD.
📸 `03-cd/05-pipeline-cd-recurso.png`.

## 18. Despliegue automatizado · *Marbel*
Log de `AzureWebApp@1` y de la prueba de humo; ejecución disparada automáticamente (motivo de recurso).
📸 `03-cd/06-despliegue-exitoso.png`, `03-cd/07-prueba-humo.png`.

## 19. Prueba de extremo a extremo · *Marlon*
Narración del cambio v1.1.0 con hora de cada paso y la **tabla de trazabilidad** (PR → SHA → CI → artefacto → CD → `/api/version`).
📸 `04-extremo-a-extremo/01` a `07`.

## 20. URL pública y comprobación de funcionamiento · *Marlon*
URL, salida de `verificar-despliegue` (5 comprobaciones) y cálculo real en la interfaz publicada.
📸 `04-extremo-a-extremo/06-app-despues-v1-1-0.png`, `08-script-verificacion.png`.

## 21. Trazabilidad de commits, ramas, PR y ejecuciones · *Juan*
Salida de `git log --oneline --graph` (texto o captura), lista de ramas y PR por integrante, relación PR ↔ ejecución de CI ↔ ejecución de CD.
📸 `01-repositorio/04-historial-commits.png`.

## 22. Distribución del trabajo · *David*
Qué hizo cada uno, con fechas y enlaces (PR, ejecuciones, capturas). Cronograma real vs. planificado.

## 23. Inconvenientes encontrados · *todos (cada uno los suyos)*
Tabla: # · síntoma · fase · responsable · evidencia (captura del error). **Solo** incidencias reales.

## 24. Soluciones implementadas · *todos*
Para cada inconveniente: causa raíz, solución, cómo se verificó, cómo se evitaría.

## 25. Seguridad · *Marlon*
Medidas de `06-seguridad.md` y salida de `buscar-secretos`.
📸 `05-equipo/02-buscar-secretos.png`.

## 26. Conclusiones · *David* (con aportes de todos)
Aprendizajes sobre CI/CD, valor de la trazabilidad, mejoras futuras (slots de staging, aprobaciones, análisis estático).

## 27. Enlaces a los videos · *Marlon*
Video 1 (CI) y Video 2 (CD), con la marca de tiempo de la intervención de cada integrante.

## 28. Anexos · *David*
- A. `azure-pipelines-ci.yml` completo.
- B. `azure-pipelines-cd.yml` completo.
- C. Scripts (`crear-recursos-azure`, `verificar-despliegue`, `buscar-secretos`).
- D. Índice de evidencias.
