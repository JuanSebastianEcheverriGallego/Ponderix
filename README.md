# Ponderix · Repositorio de respaldo (material de preparación)

Material completo para que el equipo desarrolle la **Práctica final de Despliegue de Software 2026-2 (CI + CD)**. **Este repositorio no se entrega al docente**: cada integrante toma de aquí su parte y la incorpora al repositorio oficial **`PonderixOficial`** con su propia rama, commits y Pull Request.

| Integrante | Usuario GitHub | Rol | Guía |
|---|---|---|---|
| 1 · Juan Sebastián Echeverri Gallego | `JuanSebastianEcheverriGallego` | GitHub, aplicación base y README | [guía 1](guias_integrantes/01-juan-sebastian-echeverri.md) |
| 2 · David Stiven Franco López | `Davdfranco` | Pruebas automatizadas + memoria PDF | [guía 2](guias_integrantes/02-david-franco.md) |
| 3 · Jhon Fernando Sánchez Álvarez | `Jhonzn` | Integración Continua (Azure DevOps) | [guía 3](guias_integrantes/03-jhon-sanchez.md) |
| 4 · Marbel Juliana Mejía Bedoya | `JULIANA-s22` | Entrega Continua y Azure App Service | [guía 4](guias_integrantes/04-marbel-mejia.md) |
| 5 · Marlon García Sepúlveda | `M3rl0n` | Verificación E2E, evidencias, seguridad y videos | [guía 5](guias_integrantes/05-marlon-garcia.md) |

## Empezar aquí

1. Todos: leer [01-analisis-requisitos](documentacion/01-analisis-requisitos.md) y [02-estrategia-y-distribucion](documentacion/02-estrategia-y-distribucion.md) (orden de trabajo, cronograma y dependencias).
2. **Hoy (vie 13-nov):** Juan crea el repo; Jhon crea Azure DevOps y **solicita el paralelismo**; Marbel revisa su suscripción de Azure.
3. Cada integrante sigue **su guía** en `guias_integrantes/`. La visión cronológica completa está en la [guía maestra](documentacion/03-guia-maestra.md).

## Contenido

```text
.
├── paquetes/                         Archivos listos para copiar al repo oficial, por integrante y en orden
│   ├── 01-juan-sebastian/            Aplicación .NET 10, solución, README oficial, CONTRIBUTING, plantilla PR, evidencias/
│   ├── 02-david/                     tests/Ponderix.Tests (25 pruebas xUnit)
│   ├── 03-jhon/                      pipelines/azure-pipelines-ci.yml
│   ├── 04-marbel/                    pipelines/azure-pipelines-cd.yml, scripts/crear-recursos-azure.(sh|ps1)
│   └── 05-marlon/                    scripts/verificar-despliegue.*, scripts/buscar-secretos.*, cambio visible v1.1.0
├── guias_integrantes/                Guía individual paso a paso (01 → 05)
├── documentacion/
│   ├── 01-analisis-requisitos.md     Requisitos del PDF y del mensaje de Teams, diferencias, faltantes
│   ├── 02-estrategia-y-distribucion  Decisión CI/CD, responsabilidades, cronograma, dependencias
│   ├── 03-guia-maestra.md            17 fases de cero a la entrega
│   ├── 04-flujo-git.md               Ramas, commits, PR, conflictos, fallos de CI, conservación de ramas
│   ├── 05-solucion-errores.md        Errores CI-01…10 y CD-01…11
│   ├── 06-seguridad.md               Gestión de secretos y qué hacer si se filtra uno
│   ├── 07-memoria-tecnica.md         Estructura y contenido del PDF de evidencias
│   ├── 08-matriz-evidencias.md       Requisito → evidencia → ubicación → responsable
│   ├── 09-matriz-rubricas.md         Cumplimiento criterio por criterio (CI y CD)
│   ├── 10-auditoria-tecnica.md       Qué se verificó, correcciones y pendientes reales
│   └── alternativas/                 CD por zip deploy (plan B si falla la Service Connection)
├── videos/                           Guiones de Video 1 (CI) y Video 2 (CD)
├── entregables/                      Checklist de entrega en Teams
└── scripts/ensamblar-y-verificar.sh  Ensambla los paquetes, reproduce la CI y verifica la app en local
```

## Cómo usar un paquete

Cada `paquetes/0N-*/` reproduce **las rutas del repositorio oficial**. Se copia su contenido sobre la raíz del clon de `PonderixOficial` (en una rama propia), se revisa con `git status` que solo aparecen archivos propios y se hacen los commits que indica la guía. El `README.md` oficial solo lo copia Juan; los demás **editan su sección**.

## Verificación local del material

```bash
bash scripts/ensamblar-y-verificar.sh            # requiere .NET SDK 10 y Git Bash/Linux/macOS
# → 25/25 pruebas, artefacto zip, app publicada y "RESULTADO: verificación superada"
```

## Estado

| Material | Estado |
|---|---|
| Código, pruebas, YAML, scripts, guías, plantillas | **Preparado y verificado localmente** (ver auditoría) |
| Repositorio oficial, pipelines, Azure, evidencias, videos, PDF | **Pendiente de ejecución real por el equipo** |

Ningún enlace, ejecución, URL o captura de este material es real todavía: los marcadores `[PENDIENTE: …]` se reemplazan con datos reales durante la ejecución.
