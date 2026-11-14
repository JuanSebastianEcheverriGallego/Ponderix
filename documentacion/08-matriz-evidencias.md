# 8. Matriz de evidencias

Rutas relativas al repositorio oficial `PonderixOficial`. «Estado» se marca **solo** cuando la evidencia real existe.

| Requisito | Actividad | Evidencia necesaria | Ubicación | Responsable | Cómo se verifica | Estado |
|---|---|---|---|---|---|---|
| Repo con nombre distintivo y rama `main` | Común | Página del repo | `evidencias/01-repositorio/01-repositorio-nombre-y-main.png` | Juan | Nombre `PonderixOficial`, rama por defecto `main` | ☐ |
| Acceso del docente `oalarconpe` | Común | Settings → Collaborators | `evidencias/01-repositorio/02-colaboradores-oalarconpe.png` | Juan | `oalarconpe` aparece por usuario | ☐ |
| Protección de `main` | Común | Regla con PR, aprobación y check de CI | `evidencias/01-repositorio/03-proteccion-main.png` | Juan | Regla activa | ☐ |
| README completo | Común | `README.md` sin `[PENDIENTE` | `README.md` | Juan (todos sus secciones) | `git grep PENDIENTE` vacío | ☐ |
| Commits descriptivos en `main` | CI | Historial | `evidencias/01-repositorio/04-historial-commits.png` | Marlon | Mensajes `tipo(ámbito): …` de varios autores | ☐ |
| Ramas por integrante | Común | Lista de ramas | GitHub → Branches; memoria §21 | Marlon | 9 ramas `feature/*` | ☐ |
| Pull Requests | Común | PR fusionados de los 5 | `evidencias/01-repositorio/05-pull-requests-cerrados.png` | Marlon | Autor y revisor distintos en cada PR | ☐ |
| Revisiones | Común | Aprobaciones en cada PR | Pestaña *Conversation* de cada PR | Cada revisor | «approved these changes» | ☐ |
| Ejecución local documentada | CI | README §7 | `README.md` | Juan | Seguir los pasos en un PC limpio | ☐ |
| Pipeline CI en YAML | CI | Archivo + pipeline enlazada | `pipelines/azure-pipelines-ci.yml`, `evidencias/02-ci/04-pipeline-ci-yaml.png` | Jhon | Ruta del YAML en la pipeline `ponderix-ci` | ☐ |
| Vinculación con GitHub | CI | Conexión | `evidencias/02-ci/03-conexion-github.png` | Jhon | Repo `PonderixOficial` conectado | ☐ |
| Trigger automático en `main` | CI | Ejecución con motivo automático y SHA de `main` | `evidencias/02-ci/05-disparador-automatico.png` | Jhon | Motivo ≠ *Manual*; SHA = commit de GitHub | ☐ |
| Cambio controlado que dispara CI | CI | PR insignia + ejecución | Memoria §12 | Jhon | Ejecución inmediatamente posterior al merge | ☐ |
| Restauración y compilación | CI | Log de etapas | `evidencias/02-ci/06-etapas-ci.png` | Jhon | Pasos restore/build en verde | ☐ |
| Pruebas | CI | Local y pestaña Tests | `evidencias/02-ci/01-pruebas-locales.png`, `02-pruebas-en-pipeline.png` | David | 25/25 superadas | ☐ |
| Validación de PR | CI | Check en el PR | `evidencias/02-ci/08-validacion-pr.png` | Jhon | Check verde; Empaquetar omitida | ☐ |
| Artefacto publicado | CI | Artefacto `webapp` | `evidencias/02-ci/07-artefacto-webapp.png` | Jhon | Zip + `buildinfo.json` con el SHA | ☐ |
| App Service preparado | CD | Overview y configuración | `evidencias/03-cd/01-…`, `02-…` | Marbel | Linux, .NET 10, Running, HTTPS Only | ☐ |
| Service Connection sin secretos | CD | Conexión | `evidencias/03-cd/03-service-connection.png` | Marbel | Tipo federación, ámbito `rg-ponderix` | ☐ |
| Pipeline CD | CD | YAML + pipeline | `pipelines/azure-pipelines-cd.yml`, `evidencias/03-cd/05-…` | Marbel | `ponderix-cd` con recurso `ci` | ☐ |
| Consumo del artefacto | CD | Paso de descarga y trazabilidad | `evidencias/03-cd/05-pipeline-cd-recurso.png` | Marbel | Muestra ejecución de CI y commit de origen | ☐ |
| Despliegue registrado | CD | Log de despliegue + entorno | `evidencias/03-cd/06-…`, `04-entorno-produccion.png` | Marbel | `AzureWebApp@1` verde; historial del entorno | ☐ |
| Vinculación con CI exitosa | CD | CD disparada por CI | `evidencias/04-extremo-a-extremo/05-cd-de-esa-ci.png` | Marlon | Motivo de recurso; «CD de CI <build>» | ☐ |
| URL pública | CD | Navegador | `evidencias/04-extremo-a-extremo/06-…` | Marlon | Abre sin sesión | ☐ |
| Cambio visible | CD | Antes/después | `evidencias/04-extremo-a-extremo/01-…`, `06-…` | Marlon | 1.0.0 → 1.1.0 | ☐ |
| Mismo cambio GitHub→CI→CD→Azure | CD | Tabla de trazabilidad | README §12; `evidencias/04-extremo-a-extremo/02`–`07` | Marlon | Mismo SHA en los 5 puntos | ☐ |
| Funcionalidad / salud | CD | `verificar-despliegue` | `evidencias/04-extremo-a-extremo/08-script-verificacion.png` | Marlon | «verificación superada» | ☐ |
| Sin secretos | CD | `buscar-secretos` | `evidencias/05-equipo/02-buscar-secretos.png` | Marlon | «no se detectaron secretos» | ☐ |
| Errores y soluciones | CD | Tabla | README §16; memoria §23–24 | Todos | Incidencias reales con causa y solución | ☐ |
| Video 1 (CI) | CI | Enlace YouTube | README §14 | Marlon | Abre sin sesión; 5 integrantes | ☐ |
| Video 2 (CD) | CD | Enlace YouTube | README §14 | Marlon | Abre sin sesión; 5 integrantes | ☐ |
| Documento PDF | Común | PDF | Tarea de Teams | David | Sin pendientes; capturas reales | ☐ |
| Participación de los 5 | Común | PR, revisiones, videos | `evidencias/05-equipo/01-insights-contributors.png`, memoria §22 | Marlon | Cada uno con PR propio y bloque en ambos videos | ☐ |
