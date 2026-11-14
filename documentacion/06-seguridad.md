# 6. Seguridad y gestión de secretos

## 6.1 Diseño: el repositorio no necesita ningún secreto

| Necesidad | Cómo se resuelve sin secretos en el repo |
|---|---|
| Azure DevOps lee GitHub | GitHub App *Azure Pipelines* instalada solo en `PonderixOficial` (permisos limitados al repo) |
| Azure DevOps despliega en Azure | Service Connection ARM con **federación de identidad de carga de trabajo** (sin contraseña ni secreto de cliente; tokens de corta duración) y ámbito limitado al grupo `rg-ponderix` |
| Uso de la conexión y del entorno | Sin «acceso a todas las pipelines»: cada pipeline se autoriza explícitamente (*Permit*) |
| Configuración de la app | No hay base de datos ni API externas → no hay cadenas de conexión. Si en el futuro las hubiera: *App settings* del App Service (o Key Vault), nunca `appsettings.json` |
| Valores en los YAML | Solo **nombres** (pipeline, Service Connection, App Service, entorno): no son secretos |
| Plan B (zip deploy) | Usuario/contraseña de publicación como **variables secretas** de la pipeline (Azure DevOps las enmascara con `***` en los logs) |

## 6.2 Medidas aplicadas en el repositorio

- `.gitignore` bloquea `.env*`, `*.publishsettings`, `*.pubxml.user`, `secrets.json`, `*.pfx`, `*.pem`, `*.key`, `appsettings.*.local.json`.
- *Secret scanning* y *Push protection* de GitHub activados (Settings → Code security): GitHub bloquea el push si detecta un token conocido.
- Protección de `main`: ningún cambio sin revisión.
- `scripts/buscar-secretos.sh` / `.ps1`: revisa archivos versionados **y todo el historial**.
- App Service: HTTPS Only, TLS 1.2 mínimo, FTP deshabilitado, autenticación básica SCM deshabilitada (salvo plan B).
- Capturas: se recortan IDs de suscripción/tenant, correos y cualquier token antes de subirlas.
- Proyecto público de Azure DevOps: los logs son visibles, por eso **nunca** se imprime un secreto (las variables secretas no se muestran).

## 6.3 Comprobar que no se subió nada sensible

```bash
./scripts/buscar-secretos.sh                     # o .\scripts\buscar-secretos.ps1
git ls-files | grep -Ei "\.env|publishsettings|\.pfx|secrets"   # debe salir vacío
```

Además: GitHub → **Security → Secret scanning alerts** debe estar vacío.

## 6.4 Si se sube un secreto por error

1. **Revocar o rotar primero** (el secreto se considera comprometido desde el push, aunque se borre):
   - PAT de Azure DevOps: User settings → Personal access tokens → **Revoke**.
   - Perfil de publicación: App Service → Overview → **Reset publish profile**.
   - Token de GitHub: Settings → Developer settings → **Delete**.
2. Eliminarlo del código con un PR normal (`fix(seguridad): eliminar credencial expuesta`).
3. Si debe desaparecer también del historial: avisar al equipo, usar `git filter-repo --replace-text` (o BFG) **coordinadamente**, forzar el push con la protección temporalmente relajada por Juan y pedir a todos que vuelvan a clonar. Documentarlo en la memoria.
4. Registrar el incidente en README §16.
