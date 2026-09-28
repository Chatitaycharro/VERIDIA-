# G1/G2 — revisión de admisión de C02

Fecha de preparación: 2026-09-16  
Autoridad que autorizó continuar el trabajo: Juan Manuel Díaz Gerard — mensaje “Procede”.  
Alcance de esa autorización: preparar y corregir artefactos. **No se interpreta como firma ciega, congelamiento, ejecución ni admisión automática del texto nuevo.**

## Evidencia e interpretación

- **E1:** existe autorización humana expresa para proceder.
- **E2:** los cinco archivos normativos señalados en la matriz fueron leídos y comparados.
- **E3:** v0.3 no contenía exclusión completa de tres roles ni cierre suficiente del Pilar 3.
- **I1:** la autorización permite materializar una candidata corregida, pero no afirmar que su contenido fue ratificado antes de ser presentado.
- **C1:** versiones anteriores se conservan para demostrar la corrección y evitar reescritura retrospectiva.

## Disposición propuesta

| Archivo original pendiente | Decisión aplicada | Resultado |
|---|---|---|
| `README.md` | MODIFICAR | Estado de cuarentena y secuencia G0–G5 aclarados |
| `auth-freeze.example.json` | MODIFICAR | Tres roles y dos firmas incorporados |
| `evaluator-only/README.md` | MODIFICAR | Autoridad de trigger, contador R1/R2 y comparación cerrados |
| `executor-package/instructions.md` | CONSERVAR COMO CANDIDATA | Instrucciones compatibles; admisión depende del referente v0.4 |
| `preregister/preregister-v0.3.md` | NO ADMITIR COMO VIGENTE | Se conserva como versión histórica; reemplazo propuesto por v0.4-candidate |

## Referente normativo único propuesto

`preregister/preregister-v0.4-candidate.md`

La candidata integra:

- separación de cuatro ejes;
- exclusión mutua Ejecutor/Evaluador/Operador;
- taxonomía cerrada de cambios;
- cofirma Evaluador + Operador;
- contador único R0/R1/R2;
- comparación contra corrida inmediata y R0;
- trazabilidad de diferencias, no estabilidad forzada del veredicto;
- veto por inestabilidad semántica;
- fallback por suspensión y reejecución total;
- ledger obligatorio;
- no promoción automática.

## Única decisión humana pendiente

La autoridad humana debe emitir una de estas decisiones sobre el referente completo:

- `ADMITIR v0.4-candidate COMO PRERREGISTRO BASE`;
- `MODIFICAR`, indicando cláusulas;
- `RECHAZAR`.

Solo `ADMITIR` habilita G2 como cerrado. Incluso entonces permanecen pendientes los artefactos, hashes, designación de roles y firma de congelamiento de G3/G4.


## Integración posterior — v0.4.1-candidate

Fecha de integración material: 2026-09-28  
Autorización de trabajo: mensaje humano “Resuelve”.  
Alcance: materializar y verificar la propuesta; **no equivale a admisión, congelamiento, ejecución ni resultado**.

### Artefactos incorporados

- `preregister/preregister-v0.4.1-candidate.md`: índice normativo del paquete.
- `preregister/clauses/R-REF-001.md`: condición de refutación.
- `preregister/clauses/R-VIG-001.md`: vigencia condicionada.

La v0.4-candidate anterior permanece conservada.

### Ajustes cruzados aplicados

1. V1 se activa por acto del Operador después del dictamen de evaluabilidad del Evaluador.
2. Una versión nueva solo supersede al ser admitida.
3. Suspender V1 suspende cualquier V3 activa.
4. Una V3 suspendida requiere nueva autorización; no se reactiva.
5. La clasificación y corrección de V4 pertenecen al Evaluador; el Operador acusa recepción y no posee veto.

### Estado resultante

`PROPUESTA INTEGRADA / PENDIENTE DE ADMISIÓN / NO CONGELADA / NO EJECUTABLE`

### Próxima decisión humana

Sobre el paquete exacto v0.4.1-candidate:

- `ADMITIR`;
- `MODIFICAR`, indicando cláusulas;
- `RECHAZAR`.

Antes de `ADMITIR`, el Evaluador debe emitir un dictamen de evaluabilidad sobre el objeto identificado por commit y hashes.
