# 9. Matriz de cumplimiento de las rúbricas

**Estado actual de todos los criterios: «Preparado — pendiente de ejecución real».** El material (código, YAML, scripts, guías) está listo y verificado localmente, pero ningún criterio puede marcarse como *Cumplido* hasta que exista la evidencia real en GitHub, Azure DevOps y Azure. Las columnas de estado se actualizan en la Fase 16.

## Actividad 1 · CI

| Criterio | Peso | Requisito exacto para «excelente» | Solución implementada | Evidencia que lo demuestra | Estado | Riesgos de perder puntos | Acción para asegurar el excelente |
|---|---|---|---|---|---|---|---|
| Pipeline y disparador | 30 % | Pipeline conectada a GitHub; cambio en `main` ejecuta el flujo automáticamente | `azure-pipelines-ci.yml` con `trigger: main` y `pr: main`; GitHub App; pipeline `ponderix-ci` creada con *Save* (no *Run*) | Ejecuciones con motivo automático y SHA de `main` (merge PR CI + PR insignia + PR v1.1.0) | ☐ Pendiente | Lanzar la primera ejecución con *Run*; *override* del trigger en la UI; no tener paralelismo | Pedir paralelismo el día 1; en video, mostrar el motivo «Individual CI» y el SHA |
| Construcción y validación | 25 % | Dependencias y build correctos; pruebas ejecutadas; errores diagnosticados | `dotnet restore/build/test`, `TreatWarningsAsErrors`, 25 pruebas, resultados y cobertura publicados; validación en PR | Pestaña Tests 25/25; log de etapas; incidencias en README §16 | ☐ Pendiente | Pruebas que no aparecen en la pestaña Tests; no documentar errores | David demuestra en video que una prueba fallida detiene el flujo; registrar incidencias reales |
| Artefactos CI | 25 % | Artefacto identificable, publicable y reutilizable en CD | Artefacto `webapp` con `ponderix-<build>.zip` + `buildinfo.json` (commit, build, rama); etiqueta `commit-<sha>` | Captura del artefacto; `buildinfo.json`; CD que lo descarga | ☐ Pendiente | Cambiar nombre del artefacto sin avisar a CD | Mostrar en video la cadena SHA → `buildinfo.json` → CD |
| Evidencia, explicación y equipo | 20 % | Video, README y aportes permiten seguir y reproducir | README con ejecución local y CI; guion Video 1 con los 5; PR por integrante; `evidencias/02-ci` | Video 1, README, PR | ☐ Pendiente | Algún integrante sin intervención o sin PR; capturas ilegibles | Seguir el guion; revisar `08-matriz-evidencias.md` |

## Actividad 2 · CD

| Criterio | Peso | Requisito exacto para «excelente» | Solución implementada | Evidencia que lo demuestra | Estado | Riesgos de perder puntos | Acción para asegurar el excelente |
|---|---|---|---|---|---|---|---|
| Pipeline CD y artefacto | 30 % | CD consume el artefacto de CI y despliega en App Service correctamente | `azure-pipelines-cd.yml`: recurso `ci`, `download: ci/webapp`, `AzureWebApp@1` con el `.zip`; sin build en CD | Paso de trazabilidad (ejecución y commit de origen); log de despliegue | ☐ Pendiente | Desplegar desde el IDE o reconstruir en CD; usar Deployment Center | Nunca publicar desde Visual Studio/VS Code; *Continuous deployment* del portal deshabilitado |
| Automatización extremo a extremo | 30 % | Cambio en `main` → CI exitosa → CD → nueva versión publicada | Trigger del recurso de pipeline sobre `main`; entorno sin aprobación manual; prueba de humo compara commits | Cambio v1.1.0: PR → SHA → CI → CD «CD de CI <build>» → `/api/version` | ☐ Pendiente | Lanzar la CD a mano en la demostración; CD que no se dispara por nombre mal escrito | Comprobar la CD automática con el PR de docs de Marbel antes de grabar |
| Verificación en Azure | 20 % | URL pública accesible; cambio visible; funcionamiento verificado | `/health`, `/api/version`, cálculo real; cabecera con versión; `verificar-despliegue` | Capturas antes/después; salida del script; video | ☐ Pendiente | Arranque en frío F1 o cuota agotada durante el video | Escalar a B1 el día de la grabación (CD-08) |
| Evidencia, explicación y equipo | 20 % | Video, documentación, trazabilidad y aportes completos | Guion Video 2 con los 5; tabla de trazabilidad; memoria PDF; `evidencias/03-cd` y `04-extremo-a-extremo` | Video 2, README §12, PDF | ☐ Pendiente | Narración incompleta; enlaces que no abren | Ventana privada para probar enlaces; proyecto ADO público o capturas suficientes |

## Lista de verificación final del docente (PDF, pág. 6)

| Ítem | Dónde se comprueba | Estado |
|---|---|---|
| Repo con nombre del equipo y acceso de `oalarconpe` | Fase 3 | ☐ |
| README con integrantes, responsabilidades, pipeline, URL y videos | Fase 13 | ☐ |
| CI automática en `main` que publica artefacto | Fases 7–8 | ☐ |
| CD que usa ese artefacto y publica nueva versión | Fases 10–11 | ☐ |
| Mismo cambio GitHub → CI → CD → Azure | Fase 12 | ☐ |
| Ambos videos con los cinco integrantes | Fase 14 | ☐ |
| PDF y enlaces entregados en Teams | Fase 17 | ☐ |
