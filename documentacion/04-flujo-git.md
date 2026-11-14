# 4. Flujo de trabajo con Git: ramas, commits y Pull Requests

Guía para quien apenas conoce Git. Los comandos funcionan en Git Bash, PowerShell o terminal de macOS/Linux.

## 4.1 Conceptos mínimos

| Término | Qué es |
|---|---|
| `main` | La rama oficial. Lo que hay en `main` es lo que la CI construye y la CD despliega |
| Rama `feature/...` | Copia de trabajo personal; no afecta a `main` hasta que se fusiona |
| Commit | Una «foto» de cambios con mensaje y autor |
| Push | Subir tus commits a GitHub |
| Pull Request (PR) | Solicitud para fusionar tu rama en `main`; permite revisión y validación de CI |
| Merge commit | Commit que une tu rama con `main` conservando tus commits individuales |

## 4.2 Ciclo completo (cada integrante, cada tarea)

```bash
# 1. Ir a main y traer lo último de GitHub
git switch main
git pull origin main
#    Resultado: "Already up to date." o la lista de archivos actualizados

# 2. Crear tu rama a partir de ese main actualizado
git switch -c feature/<nombre>-<tema>
#    Resultado: "Switched to a new branch 'feature/...'"

# 3. Copiar/editar archivos y revisar QUÉ cambió
git status
#    "new file" = nuevo, "modified" = modificado. Si ves modificado un archivo que no es tuyo, detente (4.3)
git diff               # ver las líneas cambiadas de archivos ya existentes

# 4. Preparar y confirmar en commits pequeños
git add <archivo1> <archivo2>
git commit -m "tipo(ámbito): descripción en presente"

# 5. Subir la rama (la primera vez con -u)
git push -u origin feature/<nombre>-<tema>
#    GitHub muestra un enlace "Create a pull request"

# 6. En GitHub: Compare & pull request → base: main → plantilla → Reviewer → Create
# 7. Esperar: check de CI en verde (cuando exista) + 1 aprobación
# 8. Merge pull request → Create a merge commit → Confirm  (NO "Delete branch")

# 9. Volver a main localmente
git switch main
git pull origin main
```

## 4.3 Cómo no sobrescribir el trabajo de otra persona

1. Antes de copiar archivos del respaldo: `git pull origin main`.
2. Después de copiar: `git status`. Solo deben aparecer **tus** archivos. Si aparece *modified* uno ajeno:
   ```bash
   git restore <archivo>        # descarta tu copia y deja la versión de main
   ```
3. El `README.md` lo editan todos: **edita solo tu sección**, nunca lo reemplaces por el del respaldo (excepto Juan en el PR #1).
4. Revisa el diff en GitHub (pestaña *Files changed*) antes de pedir revisión.

## 4.4 Convenciones

- **Ramas:** `feature/<nombre>-<tema>` en minúsculas sin tildes: `feature/david-pruebas-automatizadas`.
- **Commits:** `tipo(ámbito): descripción` con tipos `feat`, `fix`, `test`, `ci`, `cd`, `docs`, `chore`.
- **PR:** título descriptivo, plantilla completa, un revisor asignado, enlace a la evidencia si aplica.

## 4.5 Conflictos de merge

Ocurren cuando tú y otra persona cambian las mismas líneas (casi siempre en `README.md`).

```bash
git switch feature/<tu-rama>
git fetch origin
git merge origin/main
# "CONFLICT (content): Merge conflict in README.md"
```

Abre el archivo (VS Code muestra botones *Accept Current / Incoming / Both*). Verás:

```text
<<<<<<< HEAD
tu versión
=======
la versión de main
>>>>>>> origin/main
```

Deja el texto correcto (normalmente **ambos**), borra las marcas y:

```bash
git add README.md
git commit -m "chore: resolver conflicto con main en README"
dotnet build Ponderix.slnx && dotnet test Ponderix.slnx
git push
```

El PR se actualiza solo y la CI vuelve a validar.

## 4.6 La CI falla después de fusionar un PR en `main`

1. **No** se hace `git push --force` ni se borra historia: la ejecución roja también es evidencia de diagnóstico.
2. Quien fusionó abre la ejecución → paso en rojo → lee el log; si son pruebas, pestaña **Tests**.
3. Reproduce localmente: `git pull origin main && dotnet build Ponderix.slnx && dotnet test Ponderix.slnx`.
4. Corrige con una rama `fix/<nombre>-<problema>` y un PR pequeño: `fix(ci): ...`.
5. Mientras `main` esté rojo **no** se despliega nada (la CD solo se dispara con CI exitosa): Azure sigue con la última versión buena.
6. Si la corrección es compleja, revierte el merge desde GitHub (botón **Revert** en el PR fusionado) y crea luego el arreglo con calma.
7. Registra el incidente en README §16 y en la memoria (síntoma, causa, solución, responsable).

## 4.7 Corregir una entrega anterior (de otro turno)

Ejemplo: Marbel detecta que la CI publica el artefacto con otro nombre.

1. Lo comunica a Jhon (dueño de la CI) en el chat.
2. Jhon crea `fix/jhon-nombre-artefacto` desde `main` actualizado, corrige, PR revisado por Marbel.
3. Si Jhon no está disponible, Marbel puede hacer el PR, **pidiendo revisión a Jhon** y explicándolo en la descripción. La autoría queda registrada.

Nunca se edita directamente en `main` (la protección lo impide).

## 4.8 ¿Se borran las ramas después del merge?

**No hasta la entrega.** Razones: el docente puede querer ver las ramas de cada integrante, y la evidencia es más fácil de seguir.

Lo que **ya queda registrado aunque se borre la rama**: el PR (título, descripción, revisión, aprobación, checks), sus commits con autor y fecha, y el merge commit en `main` (`git log --merges`). Por eso, después de la calificación pueden borrarse las ramas sin perder trazabilidad (el PR conserva el botón *Restore branch*). Para no acumular ramas inútiles: una rama por tarea, y las ramas de prueba o abandonadas (sin PR) se borran en cuanto se descartan.

## 4.9 Comandos útiles para evidencias

```bash
git log --oneline --graph --all --decorate -30    # historial con ramas y merges
git log --merges --pretty="%h %an %s" main         # merges en main con autor
git shortlog -sn --all                              # commits por autor
git branch -r                                       # ramas en GitHub
```
