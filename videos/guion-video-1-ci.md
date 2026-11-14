# Guion · Video 1 · Integración Continua (CI)

**Duración objetivo:** 9–12 min · **Formato:** grabación de pantalla con voz (Teams/Zoom/OBS), 1080p · **Publicación:** YouTube «No listado».
**Momento:** sesión de grabación del vie 20-nov. Se graba en la misma toma que el Video 2; este video termina cuando el artefacto está publicado.

> Regla de oro: **solo se narra lo que se ve ocurriendo en pantalla**. Si algo falla durante la grabación, se diagnostica en cámara (suma puntos) o se repite; nunca se dice «aquí se ejecutaría…».

**Preparación (antes de pulsar grabar):**
- Pestañas abiertas por cada presentador según su bloque. Zoom del navegador 110–125 %.
- PR del cambio v1.1.0 de Marlon **abierto, aprobado y con el check de CI en verde, sin fusionar**.
- Cerrar correo/chat; ocultar IDs de suscripción y correos.
- La app pública muestra **1.0.0**.

---

## Bloque 1 · Presentación y repositorio — *Juan Sebastián* (≈ 2 min)

**Pantalla:** GitHub → repo `PonderixOficial`.

> «Hola, somos el equipo **Ponderix**. Soy **Juan Sebastián Echeverri Gallego** y fui responsable de la gestión de GitHub, la aplicación base y la documentación.
> Ponderix es una API y página web en .NET 10 que calcula notas ponderadas con los niveles de la rúbrica. El objetivo de la práctica es que cada cambio en `main` se valide, se empaquete y se despliegue solo en Azure.»

Mostrar, en este orden:
1. Nombre del repo y rama `main` (selector de ramas).
2. **Settings → Collaborators**: los cuatro compañeros y **`oalarconpe`**.
3. **Settings → Rules**: `main` protegida (PR obligatorio, 1 aprobación, check de CI).
4. **Pull requests → Closed**: un PR por integrante con su revisor.
5. **Commits** de `main`: mensajes `tipo(ámbito): …` de distintos autores.
6. README: sección de equipo y ejecución local.

> «Trabajamos con una rama por integrante y Pull Requests revisados. Los fusionamos con *merge commit* para conservar cada commit con su autor; así la contribución de cada uno es verificable.»

## Bloque 2 · Pruebas automatizadas — *David* (≈ 1,5 min)

**Pantalla:** VS Code con `tests/Ponderix.Tests` + terminal.

> «Soy **David Stiven Franco López**, responsable de las pruebas automatizadas.»

1. Mostrar `CalculadoraNotasTests.cs` (límites de nivel, validaciones) y `ApiTests.cs` (`WebApplicationFactory`).
2. Ejecutar `dotnet test Ponderix.slnx` → «Superado: 25».

> «Son 19 pruebas unitarias de la lógica de cálculo y 6 de integración que levantan la API en memoria. En la CI se ejecutan en la etapa Validar; si alguna falla, no se genera artefacto y por tanto no se despliega nada.»

## Bloque 3 · Pipeline de CI — *Jhon* (≈ 2 min)

**Pantalla:** `pipelines/azure-pipelines-ci.yml` en GitHub o VS Code, luego Azure DevOps.

> «Soy **Jhon Fernando Sánchez Álvarez**, responsable de la Integración Continua.»

1. YAML: `trigger: main`, `pr: main`, etapa **Validar** (SDK .NET 10, restore, build, test, resultados y cobertura), etapa **Empaquetar** con su condición (no se ejecuta en PR), `buildinfo.json`, zip y `PublishPipelineArtifact` con nombre **`webapp`**.
2. Azure DevOps → proyecto `Ponderix` → pipeline **`ponderix-ci`** → historial: ejecuciones anteriores con motivo automático.
3. Conexión con GitHub (Project settings → GitHub connections).

> «Decidimos separar validación y empaquetado para que en los Pull Requests solo se valide, y que el artefacto desplegable salga únicamente de `main`. Usamos los mismos comandos `dotnet` que en local para que el proceso sea reproducible.»

## Bloque 4 · El cambio controlado — *Marlon* (≈ 1,5 min)

**Pantalla:** GitHub → PR «Versión 1.1.0…».

> «Soy **Marlon García Sepúlveda**, responsable de la verificación extremo a extremo y de las evidencias. Este es el cambio que vamos a seguir desde GitHub hasta Azure.»

1. *Files changed*: `AppInfo.cs` 1.0.0 → 1.1.0 y la novedad; `CHANGELOG.md`.
2. Check de CI del PR en verde (validación), aprobación de Marbel.
3. **Merge pull request → Create a merge commit → Confirm** (en vivo).
4. **Commits** de `main`: señalar el SHA del merge (leer los 7 primeros caracteres en voz alta).

> «No vamos a pulsar ningún botón en Azure DevOps: el merge en `main` es lo único que hacemos.»

## Bloque 5 · Ejecución automática y artefacto — *Jhon* (≈ 2,5 min)

**Pantalla:** Azure DevOps → `ponderix-ci`.

1. Aparece la nueva ejecución **sola**: señalar **motivo automático** (*Individual CI*), rama `main` y el **mismo SHA**.
2. Abrir la ejecución: etapas **Validar → Empaquetar** avanzando; abrir el log de `Ejecutar pruebas` y `Generar buildinfo.json`.
3. Al terminar: pestaña **Tests** (25/25) y **Code Coverage**.
4. **Artefacto `webapp`**: `ponderix-<build>.zip` y `buildinfo.json`; abrir `buildinfo.json` y comparar `commit` con el SHA de GitHub. Mostrar la etiqueta `commit-<sha>`.

> «Esta es la relación que pide la práctica: commit `xxxxxxx` en `main` → ejecución `<número>` → artefacto `ponderix-<número>.zip`, que lleva dentro el mismo commit.»

## Bloque 6 · El artefacto como contrato con la CD — *Marbel* (≈ 1 min)

**Pantalla:** el artefacto `webapp` abierto.

> «Soy **Marbel Juliana Mejía Bedoya**, responsable de la Entrega Continua y de Azure. Este artefacto es lo único que recibe la CD: un paquete inmutable, identificado por número de ejecución y commit. La CD no vuelve a compilar; despliega exactamente lo que la CI validó. Lo veremos en el segundo video.»

**Cierre (Juan, 15 s):** «Con esto la Integración Continua queda demostrada: un commit en `main`, validado y empaquetado automáticamente. Continuamos en el video de Entrega Continua.»

---

## Checklist de edición
- [ ] Los 5 integrantes dicen su **nombre completo** y su **rol**.
- [ ] Se ve el motivo automático de la ejecución y el mismo SHA en GitHub, CI y `buildinfo.json`.
- [ ] Se ven las etapas, la pestaña Tests y el artefacto.
- [ ] No se ve ningún dato sensible.
- [ ] Descripción de YouTube con enlace al repo y marcas de tiempo por integrante.
