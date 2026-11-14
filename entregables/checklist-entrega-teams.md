# Checklist de entrega en Microsoft Teams

**Tarea:** «Práctica final CI y CD» · **Cierra:** lunes 23-nov-2026 23:59 · **Objetivo interno:** entregar antes de las 12:00 del lunes.
**Responsables:** Marlon (entrega) y David (PDF).

## 1. Antes de entregar (comprobar en una ventana privada del navegador, sin sesión)

- [ ] El repo `https://github.com/JuanSebastianEcheverriGallego/PonderixOficial` abre y el README se ve completo.
- [ ] `oalarconpe` figura en Settings → Collaborators (aceptado o invitación enviada; captura guardada).
- [ ] `git grep PENDIENTE` en `main` no devuelve nada.
- [ ] La URL pública abre y muestra la versión **1.1.0**.
- [ ] Los enlaces a ejecuciones de Azure DevOps del README abren (si el proyecto es privado, las capturas de `evidencias/` lo cubren y se indica en el README).
- [ ] Video 1 (CI) abre sin sesión y dura lo previsto.
- [ ] Video 2 (CD) abre sin sesión y dura lo previsto.
- [ ] El PDF abre, no tiene `[PENDIENTE]`/`[INSERTAR]` y sus enlaces son clicables.
- [ ] `scripts/buscar-secretos.sh` sin hallazgos.
- [ ] `documentacion/09-matriz-rubricas.md` revisada: cada criterio con evidencia real.

## 2. Qué se adjunta en la tarea

| # | Entregable | Formato |
|---|---|---|
| 1 | Enlace al repositorio GitHub | Enlace |
| 2 | Enlace al Video 1 · Integración Continua | Enlace YouTube |
| 3 | Enlace al Video 2 · Entrega Continua | Enlace YouTube |
| 4 | Memoria técnica `Ponderix-Memoria-Tecnica-CICD.pdf` | Archivo PDF |

Texto sugerido para el comentario de la entrega:

```text
Equipo Ponderix — Práctica final CI/CD
Integrantes: Juan Sebastián Echeverri Gallego, David Stiven Franco López, Jhon Fernando Sánchez Álvarez,
Marbel Juliana Mejía Bedoya, Marlon García Sepúlveda.
Repositorio: [enlace]  (colaborador: oalarconpe)
URL pública: [enlace]
Video 1 · CI: [enlace]
Video 2 · CD: [enlace]
Memoria técnica: adjunta en PDF.
```

## 3. Después de entregar

- [ ] Captura del estado «Entregado» en Teams.
- [ ] No modificar `main` hasta la calificación (o, si se corrige algo, volver a entregar: se permiten varios envíos).
- [ ] Mantener el App Service encendido hasta recibir la nota; luego `az group delete -n rg-ponderix` para no consumir crédito.
- [ ] Revocar PAT o credenciales temporales que se hayan creado.
