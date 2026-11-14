# Guía 2 · David Stiven Franco López (`@Davdfranco`)

**Rol:** Pruebas automatizadas y calidad + edición final de la memoria técnica (PDF).
**Turno:** 2 de 5 · **Fechas objetivo:** sáb 14-nov → dom 15-nov-2026.
**Recibes de:** Juan Sebastián · **Entregas a:** Jhon · **Revisor de tu PR:** Juan Sebastián.

Tus pruebas son lo que la CI ejecuta en la etapa **Validar**: si una prueba falla, no se genera artefacto y **no hay despliegue**. Es la «puerta de calidad» de todo el flujo. Además, consolidas el documento PDF final.

---

## 0. Qué debes esperar antes de comenzar

- [ ] Juan te confirmó «`main` lista para pruebas» (su PR está fusionado).
- [ ] Aceptaste la invitación de colaborador al repo `ponderix` (revisa tu correo o <https://github.com/notifications>).
- [ ] Git configurado con tu nombre y el correo de tu cuenta de GitHub:
  ```bash
  git config --global user.name "David Stiven Franco López"
  git config --global user.email "<correo de tu cuenta de GitHub>"
  ```
- [ ] .NET SDK 10 (`dotnet --version` → `10.0.x`).

**Mientras esperas puedes adelantar:** leer `src/Ponderix.Api/Dominio/CalculadoraNotas.cs` en el respaldo, ejecutar localmente las pruebas del paquete 02 con el script `scripts/ensamblar-y-verificar.sh _prueba 2` del respaldo, y revisar el PR de Juan (tú eres su revisor).

### Revisar el PR de Juan (te toca antes de tu turno)

```bash
git clone https://github.com/JuanSebastianEcheverriGallego/ponderix.git
cd ponderix
git fetch origin
git switch feature/juan-sebastian-base-aplicacion
dotnet build Ponderix.slnx
dotnet run --project src/Ponderix.Api --launch-profile http   # probar http://localhost:5080 y /health
```

En GitHub → PR → **Files changed** → **Review changes** → comentario (p. ej. «Compila sin advertencias, /health responde Healthy, la interfaz calcula correctamente») → **Approve** → **Submit review**.

## 1. Material que tomas del repositorio de respaldo

`paquetes/02-david/tests/Ponderix.Tests/`:

| Archivo | Contenido |
|---|---|
| `Ponderix.Tests.csproj` | Proyecto xUnit (.NET 10) con `Microsoft.AspNetCore.Mvc.Testing` y `coverlet.collector` |
| `CalculadoraNotasTests.cs` | 19 casos unitarios: cálculo ponderado, redondeo, límites de cada nivel, validaciones |
| `ApiTests.cs` | 6 pruebas de integración: `/health`, `/api/version`, `/api/rubricas`, cálculo 200/400, página web |

## 2. Rama y commits

```bash
# 1. Actualizar main (ya contiene la aplicación de Juan)
git switch main
git pull origin main

# 2. Crear tu rama
git switch -c feature/david-pruebas-automatizadas

# 3. Copiar el paquete (solo añade la carpeta tests/, no toca archivos de Juan)
cp -r /c/respaldo-ponderix/paquetes/02-david/. .
git status        # debe mostrar únicamente tests/ como nuevo
```

**Comprobación de no sobrescritura:** `git status` no debe listar archivos *modified* de `src/` ni `README.md`. Si aparecen, ejecuta `git restore <archivo>` y vuelve a copiar solo `tests/`.

**Commit 1 — crear el proyecto y registrarlo en la solución:**

```bash
dotnet sln Ponderix.slnx add tests/Ponderix.Tests/Ponderix.Tests.csproj
# → "Se ha agregado el proyecto ... a la solución"
git add Ponderix.slnx tests/Ponderix.Tests/Ponderix.Tests.csproj
git commit -m "test: crear proyecto de pruebas xUnit y registrarlo en la solución"
```

**Commit 2 — pruebas unitarias:**

```bash
git add tests/Ponderix.Tests/CalculadoraNotasTests.cs
git commit -m "test(dominio): agregar pruebas unitarias de CalculadoraNotas y niveles de la rúbrica"
```

**Commit 3 — pruebas de integración:**

```bash
git add tests/Ponderix.Tests/ApiTests.cs
git commit -m "test(api): agregar pruebas de integración de los endpoints con WebApplicationFactory"
```

**Ejecuta y comprueba:**

```bash
dotnet test Ponderix.slnx
# Resultado esperado:
# Correctas! - Con error: 0, Superado: 25, Omitido: 0, Total: 25
dotnet test Ponderix.slnx --collect "XPlat Code Coverage"   # genera TestResults/**/coverage.cobertura.xml
```

📸 `evidencias/02-ci/01-pruebas-locales.png` (terminal con «Superado: 25»).

**Demuestra que las pruebas detectan errores (para el video y la memoria):** cambia temporalmente en `CalculadoraNotas.cs` `>= 4.5m => "Excelente"` por `>= 4.6m`, ejecuta `dotnet test` (falla la prueba del límite 4.5 → «Excelente») y **revierte** con `git restore src/Ponderix.Api/Dominio/CalculadoraNotas.cs`. No subas ese cambio.

**Commit 4 — documentación:** en `README.md`, reemplaza el marcador de la sección 8 por:

```markdown
El proyecto `tests/Ponderix.Tests` contiene **25 pruebas** (xUnit):

- **Unitarias (19)** — `CalculadoraNotasTests`: promedio ponderado y redondeo, tolerancia de pesos (33.33 + 33.33 + 33.34),
  límites exactos de cada nivel (4.5, 3.5, 2.5) y validaciones (sin criterios, pesos que no suman 100, notas fuera de 0–5, nombre vacío).
- **Integración (6)** — `ApiTests`: levanta la API en memoria con `WebApplicationFactory` y comprueba `/health`,
  `/api/version`, `/api/rubricas`, `POST /api/notas/calcular` (200 y 400) y que `/` sirve la interfaz.

En la CI se ejecutan en la etapa **Validar**; si alguna falla, la etapa **Empaquetar** no se ejecuta y no hay despliegue.
```

En la tabla del equipo cambia `[PENDIENTE: enlace al PR]` de tu fila cuando tengas el número del PR (puedes hacerlo en un commit posterior en la misma rama).

```bash
git add README.md
git commit -m "docs(readme): documentar pruebas automatizadas"
git push -u origin feature/david-pruebas-automatizadas
```

## 3. Pull Request

- **Título:** `Pruebas automatizadas unitarias y de integración (xUnit)`.
- **Descripción:** completa la plantilla. Incluye: «25 pruebas superadas localmente; cobertura con coverlet; la CI las ejecutará en la etapa Validar.»
- **Reviewer:** `JuanSebastianEcheverriGallego`.
- Tras la aprobación: **Create a merge commit**. No borres la rama.

```bash
git switch main
git pull origin main
dotnet test Ponderix.slnx      # en main también 25/25
```

## 4. Cuando Jhon tenga la CI

Abre la primera ejecución de `ponderix-ci` en Azure DevOps → pestaña **Tests**: deben aparecer 25 pruebas superadas y la pestaña **Code Coverage**.
📸 `evidencias/02-ci/02-pruebas-en-pipeline.png`.

## 5. Responsabilidad adicional: memoria técnica PDF

Eres el **editor** de la memoria (`documentacion/07-memoria-tecnica.md` del respaldo):

1. Desde el sáb 21-nov, copia la plantilla en un documento compartido (Word/Google Docs).
2. Cada integrante rellena sus apartados (la plantilla indica quién).
3. Insertas las capturas reales de `evidencias/` en los lugares indicados.
4. Revisas que no queden `[PENDIENTE]` y exportas a PDF: `Ponderix-Memoria-Tecnica-CICD.pdf`.
5. Lo entregas a Marlon a más tardar el dom 22-nov para la revisión final.

## 6. No continúes hasta comprobar lo siguiente

- [ ] `dotnet test Ponderix.slnx` en `main` → **25 superadas, 0 con error**.
- [ ] `Ponderix.slnx` contiene `src/Ponderix.Api` **y** `tests/Ponderix.Tests` (ábrelo y compruébalo).
- [ ] `git ls-files | grep -E "bin/|obj/|TestResults"` no devuelve nada.
- [ ] Tu PR está fusionado con merge commit y la rama sigue existiendo.

## 7. Al finalizar mi parte debo entregar

| Entregable | A quién |
|---|---|
| Confirmación «solución con pruebas lista en `main`; comando de prueba: `dotnet test Ponderix.slnx`» | **Jhon** (siguiente) |
| Enlace a tu PR | Marlon / Juan |
| Captura `02-ci/01-pruebas-locales.png` (y luego `02-pruebas-en-pipeline.png`) | Marlon |
| PDF final de la memoria | Marlon (dom 22-nov) |

## 8. Qué explicas en los videos

- **Video 1 (CI):** «Soy David Stiven Franco López, responsable de las pruebas automatizadas». Muestra `tests/Ponderix.Tests`, ejecuta `dotnet test` en local y luego la pestaña **Tests** de la ejecución de CI. Explica qué cubren las unitarias y las de integración y que una prueba fallida detiene el flujo (no hay artefacto ni despliegue).
- **Video 2 (CD):** explica que la CD solo se dispara cuando la CI termina **con éxito**: las pruebas son la condición previa del despliegue. Muestra las pruebas de la ejecución de CI asociada al cambio v1.1.0.

## 9. Problemas frecuentes

| Síntoma | Solución |
|---|---|
| `error NU1101/NU1102` al restaurar | Sin conexión a nuget.org o proxy; reintenta `dotnet restore`. |
| `WebApplicationFactory<Program>` no compila | `Program.cs` debe terminar con `public partial class Program;` (ya incluido). |
| `dotnet test` no encuentra pruebas | El proyecto no está en la solución: repite `dotnet sln Ponderix.slnx add ...`. |
| Conflicto en `README.md` al actualizar | `git fetch origin && git merge origin/main`, resuelve conservando ambos textos, `git add README.md && git commit`. |
