#!/usr/bin/env bash
# =============================================================================
# Repositorio de RESPALDO · Ensambla los paquetes 01..N en una carpeta temporal,
# reproduce localmente los pasos de la CI (restore, build, test, publish,
# buildinfo.json, zip) y verifica la aplicación publicada con el script de Marlon.
#
# Uso (Git Bash, Linux o macOS), desde la raíz del repositorio de respaldo:
#   ./scripts/ensamblar-y-verificar.sh [carpeta-destino] [hasta-paquete]
# Ejemplos:
#   ./scripts/ensamblar-y-verificar.sh                 # paquetes 1..5 en ./_ensamblado
#   ./scripts/ensamblar-y-verificar.sh /tmp/ponderix 2 # solo app + pruebas
#
# NO sustituye a la CI real de Azure DevOps: sirve para comprobar que el material
# es coherente ANTES de copiarlo al repositorio principal.
# =============================================================================
set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
DESTINO="${1:-$RAIZ/_ensamblado}"
HASTA="${2:-5}"
PUERTO=5099

echo "==> Ensamblando paquetes 1..$HASTA en $DESTINO"
rm -rf "$DESTINO"
mkdir -p "$DESTINO"
i=0
for paquete in "$RAIZ"/paquetes/0*; do
  i=$((i+1))
  [ "$i" -gt "$HASTA" ] && break
  echo "    + $(basename "$paquete")"
  cp -r "$paquete/." "$DESTINO/"
  # Paso manual de David: registrar el proyecto de pruebas en la solución.
  if [ "$(basename "$paquete")" = "02-david" ]; then
    (cd "$DESTINO" && dotnet sln Ponderix.slnx add tests/Ponderix.Tests/Ponderix.Tests.csproj >/dev/null)
  fi
done

cd "$DESTINO"
echo "==> [CI · Validar] restore / build / test"
dotnet restore Ponderix.slnx
dotnet build Ponderix.slnx --configuration Release --no-restore
if [ -d tests ]; then
  dotnet test Ponderix.slnx --configuration Release --no-build --logger trx --results-directory ./TestResults --collect "XPlat Code Coverage"
fi

echo "==> [CI · Empaquetar] publish + buildinfo.json + zip"
dotnet publish src/Ponderix.Api/Ponderix.Api.csproj --configuration Release --output ./publish
cat > ./publish/buildinfo.json <<EOF
{ "build": "verificacion-local", "commit": "verificacion-local", "rama": "local", "fechaBuild": "$(date -u +%Y-%m-%dT%H:%M:%SZ)" }
EOF
if command -v zip >/dev/null 2>&1; then
  (cd publish && zip -qr ../ponderix-local.zip .)
elif command -v powershell.exe >/dev/null 2>&1; then
  powershell.exe -NoProfile -Command "Compress-Archive -Path publish/* -DestinationPath ponderix-local.zip -Force"
fi
ls -la ponderix-local.zip 2>/dev/null || echo "    (no hay herramienta zip; se omite el .zip local)"

if [ -f scripts/verificar-despliegue.sh ]; then
  echo "==> Arrancando la aplicación publicada en http://localhost:$PUERTO"
  # Se lanza dotnet directamente (sin subshell) para que $! sea su PID y el trap lo detenga.
  ASPNETCORE_URLS="http://localhost:$PUERTO" dotnet publish/Ponderix.Api.dll --contentRoot "$DESTINO/publish" >app.log 2>&1 &
  PID=$!
  trap 'kill $PID 2>/dev/null || true' EXIT
  for _ in $(seq 1 30); do
    curl -fs "http://localhost:$PUERTO/health" >/dev/null 2>&1 && break
    sleep 1
  done
  bash scripts/verificar-despliegue.sh "http://localhost:$PUERTO" verificacion-local
fi

echo "==> Ensamblado y verificación completados en $DESTINO"
