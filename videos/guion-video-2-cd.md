# Guion · Video 2 · Entrega Continua (CD)

**Duración objetivo:** 10–12 min · **Publicación:** YouTube «No listado».
**Momento:** continúa la misma toma del Video 1: la CI del cambio v1.1.0 acaba de terminar.

> Igual que en el Video 1: solo se narra lo que se ve. Si la CD tarda (arranque en frío), se aprovecha para explicar la configuración de Azure.

---

## Bloque 1 · Recordatorio del cambio — *Juan Sebastián* (≈ 1 min)

**Pantalla:** GitHub → PR v1.1.0 fusionado → commit en `main`.

> «Soy **Juan Sebastián Echeverri Gallego**. Seguimos el mismo cambio del video anterior: el PR de Marlon que sube la aplicación a la versión 1.1.0, fusionado en `main` con el commit `xxxxxxx`. Ahora veremos cómo llega solo a Azure.»

Mostrar la tabla de trazabilidad del README (sección 12) que se completará con los datos de esta demostración.

## Bloque 2 · Las pruebas como condición — *David* (≈ 1 min)

**Pantalla:** ejecución de CI del cambio → pestaña Tests.

> «Soy **David Stiven Franco López**. La CD solo se activa si la CI termina **con éxito**: estas 25 pruebas superadas son la condición para desplegar. Si una fallara, Azure seguiría con la versión anterior.»

## Bloque 3 · La CI que dispara la CD — *Jhon* (≈ 1 min)

**Pantalla:** Azure DevOps → `ponderix-cd` → ejecución nueva.

> «Soy **Jhon Fernando Sánchez Álvarez**. Al terminar la CI, Azure DevOps lanzó sola la pipeline de CD.»

1. Señalar que la ejecución se llama **«CD de CI <número>»** y su motivo es el **recurso de pipeline** (no manual).
2. En la ejecución → **Resources/artefactos**: el recurso `ci` apunta a la ejecución `<número>` de `ponderix-ci`, rama `main`, commit `xxxxxxx`.

## Bloque 4 · Azure y la pipeline de CD — *Marbel* (≈ 4 min)

> «Soy **Marbel Juliana Mejía Bedoya**, responsable de la CD y de Azure.»

**4a · Azure (portal):** App Service `ponderix-<sufijo>`: Linux, .NET 10, *Running*, URL; Configuration (comando de inicio, HTTPS Only, TLS 1.2, FTP deshabilitado); Health check `/health`. Explicar que *Continuous deployment* del portal está deshabilitado porque la CD es Azure DevOps.

**4b · Seguridad:** Service Connection `sc-azure-ponderix` (federación de identidad, sin contraseñas, ámbito `rg-ponderix`). «En el repositorio no hay ningún secreto: el YAML solo contiene nombres.»

**4c · YAML de CD:** `trigger: none`, `resources.pipelines` (`source: ponderix-ci`, `trigger: main`), `deployment` con `environment: ponderix-produccion`, `download: ci / webapp`, `AzureWebApp@1` con el `.zip`, prueba de humo.

> «La CD no reacciona a commits: reacciona a que la CI termine bien en `main`. Y no compila: descarga el artefacto de esa ejecución. No pusimos aprobación manual en el entorno para que el flujo sea totalmente automático; si la añadiéramos, la CD se quedaría esperando a que alguien aprobara.»

**4d · Ejecución en curso:** pasos *Descargar artefacto* → *Trazabilidad* (leer ejecución y commit recibidos y el contenido de `buildinfo.json`) → *Desplegar .zip en App Service* → *Prueba de humo* (espera hasta que `/api/version` devuelva el commit nuevo) ✅.
**4e · Entorno** `ponderix-produccion` → historial de despliegues con esta ejecución.

## Bloque 5 · Verificación en la URL pública — *Marlon* (≈ 2,5 min)

> «Soy **Marlon García Sepúlveda**. Comprobemos el resultado en Azure.»

1. Navegador → `https://ponderix-<sufijo>.azurewebsites.net` (Ctrl+F5): la cabecera dice **«Versión 1.1.0: Nueva versión desplegada automáticamente…»**; el pie muestra `build <número> · commit xxxxxxx`.
2. Usar la aplicación: plantilla «Nota final de la práctica», notas 4.5 y 5.0 → **4.75 Excelente**.
3. `/health` → `Healthy`; `/api/version` → mismo `commit` y `build`.
4. Terminal: `./scripts/verificar-despliegue.sh https://ponderix-<sufijo>.azurewebsites.net` → 5 comprobaciones OK, «verificación superada».

**Cierre (Marlon, 30 s):**
> «Resumen: commit `xxxxxxx` en `main` → CI `<número>` con 25 pruebas → artefacto `ponderix-<número>.zip` → CD «CD de CI `<número>`» → Azure App Service mostrando la versión 1.1.0 con el mismo commit. Todo sin intervención manual después del merge. Gracias.»

---

## Checklist de edición
- [ ] Los 5 se identifican con nombre completo y rol.
- [ ] Se ve que la CD fue disparada por la CI (no manual) y qué artefacto recibió.
- [ ] Se ve el log de despliegue exitoso y la prueba de humo.
- [ ] Se ve la URL pública con el cambio visible y una funcionalidad real.
- [ ] El mismo SHA aparece en GitHub, CI, CD y `/api/version`.
- [ ] Sin datos sensibles en pantalla.
