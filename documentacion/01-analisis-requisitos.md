# 1. Análisis de la actividad

Fuentes analizadas: **(A)** PDF «Práctica final – Integración Continua (CI) y Entrega Continua (CD)» (6 páginas) y **(B)** mensaje/instrucciones del docente en Microsoft Teams. Fecha límite: **lunes 23-nov-2026, 23:59** (se permiten varios envíos).

## 1.1 Qué pide realmente el profesor

No pide una aplicación compleja: pide **demostrar un flujo automatizado y trazable**:

> Código en GitHub → CI → Artefacto → CD → Aplicación en Azure App Service

La frase clave del PDF es: *«El evaluador debe poder verificar la relación entre un commit en main, la ejecución de la pipeline y el artefacto que será consumido por CD»* y *«No basta con publicar una vez desde el IDE»*. Todo el diseño de esta solución gira alrededor de poder **seguir un mismo SHA** de commit por cada eslabón (por eso existen `buildinfo.json`, `/api/version` y la prueba de humo que compara commits).

## 1.2 Requisitos separados

### Requisitos de CI (Actividad 1 · 50 %)

| ID | Requisito | Fuente |
|---|---|---|
| CI-R1 | Aplicación funcional alojada en el repo de GitHub del equipo | A |
| CI-R2 | Documentar la ejecución local | A |
| CI-R3 | Trabajar sobre `main` con varios commits descriptivos que evidencien avances reales | A |
| CI-R4 | Pipeline de CI en Azure DevOps vinculada al repo de GitHub; disparador en cambios de `main` | A |
| CI-R5 | Pasos de restauración de dependencias, compilación y pruebas automatizadas (o explicar su ausencia en el README) | A |
| CI-R6 | Generar y publicar un artefacto reutilizable por la CD, claramente identificado | A |
| CI-R7 | Provocar un cambio controlado en `main` y demostrar que la CI se ejecuta sin lanzarla manualmente | A |
| CI-E | Evidencias: YAML, historial con `main`, ejecución y etapas, artefacto, **Video 1** narrado | A, B («compilación y generación de artefactos») |

### Requisitos de CD (Actividad 2 · 50 %)

| ID | Requisito | Fuente |
|---|---|---|
| CD-R1 | Preparar Azure App Service compatible y documentar su configuración esencial | A |
| CD-R2 | Pipeline o etapa de CD que consuma el artefacto de CI **sin reconstruir** | A |
| CD-R3 | Vincular el despliegue con la finalización **exitosa** de CI (automático) | A |
| CD-R4 | Cambio visible y controlado: mostrar commit, ejecución CI, ejecución CD y app actualizada | A |
| CD-R5 | URL pública accesible + funcionalidad real o comprobación de salud | A |
| CD-R6 | Documentar errores, ajustes y medidas para no exponer secretos | A |
| CD-E | Evidencias: configuración CD + artefacto, CI y CD del mismo cambio, registro de despliegue, URL, **Video 2** | A, B |

### Requisitos compartidos

| ID | Requisito | Fuente |
|---|---|---|
| G-1 | Repo con nombre distintivo (no «practica-final», «PracticaFinal», «ProyectoCI-CD») | A, B (B añade ejemplos) |
| G-2 | Colaborador GitHub **`oalarconpe`** (por usuario, no por correo) y comprobar acceso | A, B |
| G-3 | README: equipo, nombres completos, roles y contribuciones; tecnología; descripción; rama; ejecución; configuración; flujo CI/CD; enlaces a ejecuciones/evidencias; URL; videos | A, B |
| G-4 | Archivos de pipelines organizados y carpeta `/evidencias/` con capturas legibles | A |
| G-5 | Sin tokens, contraseñas, cadenas de conexión ni secretos de Azure en el repo | A |
| G-6 | Cada integrante con responsabilidad concreta, participación en la demostración y aporte verificable | A, B |
| G-7 | Videos: cada integrante se identifica y explica su parte; pantallas reales de GitHub, Azure DevOps y Azure | A |
| G-8 | Memoria técnica PDF: configuración, evidencias, problemas y solución, distribución del trabajo | A, B |
| G-9 | Entrega en la tarea de Teams: enlace repo, 2 videos (YouTube accesible), PDF | A, B |

## 1.3 Diferencias y complementos del mensaje de Teams respecto al PDF

| Tema | PDF | Teams | Consecuencia |
|---|---|---|---|
| Nombres prohibidos | «practica-final» | «PracticaFinal», «ProyectoCI-CD» | Se elige `ponderix` |
| Participación | Responsabilidad concreta + evidencia | «todos deben participar **activamente** en configuración, implementación, documentación y demostración» | Cada integrante hace PR técnicos **y** documentales y aparece en ambos videos |
| Video CI | Demostración de CI | Explícitamente «incluyendo la **compilación y generación de artefactos**» | El guion dedica bloques a etapas y artefacto |
| PDF | Memoria técnica | «Documento PDF de **evidencias técnicas**: explicación, capturas, configuraciones, inconvenientes y soluciones» | La memoria se centra en capturas reales comentadas |
| Entrega | En Teams | «**exclusivamente** dentro de esta tarea» y verificar permisos del docente sobre repo **y evidencias** | Proyecto de Azure DevOps público (o capturas suficientes) y videos «No listado» |
| Evaluación | Rúbricas | Se valora también «comprensión del proceso» y «calidad de la documentación» | Cada guía incluye qué explicar y por qué |
| Fecha | — | 23-nov-2026 23:59, varios envíos | Plan con colchón: entrega el lunes por la mañana |

No hay contradicciones; Teams **refuerza** participación, accesibilidad de evidencias y explicación.

## 1.4 Rúbricas (resumen)

| CI | Peso | | CD | Peso |
|---|---|---|---|---|
| Pipeline y disparador | 30 % | | Pipeline CD y artefacto | 30 % |
| Construcción y validación | 25 % | | Automatización extremo a extremo | 30 % |
| Artefactos CI | 25 % | | Verificación en Azure | 20 % |
| Evidencia, explicación y equipo | 20 % | | Evidencia, explicación y equipo | 20 % |

Nota final = CI × 0,5 + CD × 0,5. Análisis criterio por criterio en `09-matriz-rubricas.md`.

## 1.5 Dependencias y restricciones identificadas

1. **Paralelismo de Azure Pipelines**: las organizaciones nuevas pueden tener 0 agentes hospedados hasta que Microsoft aprueba la solicitud gratuita (2–3 días hábiles). Es el mayor riesgo de calendario → se gestiona el día 1.
2. **GitHub App de Azure Pipelines**: solo el propietario del repo puede instalarla → Juan participa en el paso de Jhon.
3. **Service Connection con federación**: requiere poder registrar aplicaciones en Entra ID; en tenants universitarios puede estar bloqueado → plan B documentado (CD-02).
4. **Nombre de la pipeline de CI**: la CD la referencia por nombre (`ponderix-ci`).
5. **El artefacto es el contrato** CI ↔ CD: nombre `webapp`, un `.zip` + `buildinfo.json`.
6. **Primera ejecución de CD**: debe autorizar Service Connection y entorno (una vez, manual); a partir de ahí es automática.
7. **Usuarios de Azure DevOps**: el nivel *Basic* es gratis hasta 5 usuarios: justo el equipo.

## 1.6 Información que falta (debe aportar el equipo)

| Dato | Quién lo define |
|---|---|
| Propietario definitivo del repo (se propone la cuenta de Juan) | Equipo |
| Organización de Azure DevOps (nueva o existente de prácticas anteriores) | Jhon |
| Suscripción de Azure a usar y región permitida | Marbel |
| Nombre único del App Service (`ponderix-<sufijo>`) | Marbel |
| Correos/cuentas Microsoft de cada integrante para Azure DevOps | Cada integrante |
| Canal de YouTube para publicar los videos | Marlon |
| Si el docente necesita acceso al proyecto de Azure DevOps (si es privado) | Consultar al docente |

## 1.7 Videos del docente

Los cuatro videos de apoyo (YouTube) **no se han podido consultar** en esta preparación: no tengo acceso al contenido de video ni a sus transcripciones. Lo que se asume de ellos se limita a lo que dice el PDF: usan .NET y Visual Studio y un flujo «Pipeline» (CI) + «Release» (CD). Esta solución usa .NET (coherente con los videos) y define la CD como **pipeline YAML con recurso de pipeline**, que es el equivalente moderno y versionado de una *Classic Release* con *continuous deployment trigger* sobre el artefacto de build. **Recomendación:** que Jhon y Marbel vean los videos 1 y 2–4 respectivamente; si el docente usa *Classic Release*, en la explicación oral pueden mencionar la equivalencia: artefacto de build ↔ `resources.pipelines`, *CD trigger* ↔ `trigger` del recurso, *stage* de release ↔ `deployment` + `environment`, tarea *Azure App Service deploy* ↔ `AzureWebApp@1`.
