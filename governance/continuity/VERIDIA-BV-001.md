# VERIDIA-BV-001 — Bitácora Viva y Registro de Continuidad

**Versión:** 0.1  
**Estado del instrumento:** EN REVISIÓN  
**Fuente canónica:** este archivo en el repositorio `Chatitaycharro/VERIDIA-`

## 1. Propósito

Preservar el presente operativo de Veridia mientras ocurre, mediante entradas breves, trazables, auditables y corregibles. La Bitácora registra evidencia, inferencias, decisiones, acciones, omisiones deliberadas, riesgos, pendientes y autorizaciones. No sustituye al Arqueólogo Digital ni al registro de contexto externo.

## 2. Separación funcional

- **Arqueólogo Digital:** reconstruye la genealogía interna de Veridia.
- **Bitácora Viva:** registra el presente operativo de Veridia.
- **Contexto externo:** preserva el entorno contemporáneo sin contaminar la cronología interna ni atribuir causalidad retrospectiva.

## 3. Reglas

1. **Fuente canónica única.** Este archivo es el registro canónico. Los respaldos son réplicas fechadas de solo lectura, no fuentes editables paralelas.
2. **Escritura acumulativa.** Corregir es añadir. Ninguna corrección borra o sobreescribe la entrada original.
3. **Cierre por episodio o por día.** Ningún episodio relevante debe quedar únicamente en una conversación.
4. **Referencia obligatoria.** Toda decisión debe citar la evidencia que la originó.
5. **Separación E/I.** La evidencia y la inferencia se registran por separado. La evidencia secundaria no sostiene por sí sola una inferencia fuerte; toda inferencia basada únicamente en relato se marca como provisional.
6. **Estados independientes.** El estado del registro, el estado de la acción, el estado de la integración técnica y la autorización no se deducen entre sí.
7. **Autorización humana.** Juan Manuel Díaz Gerard autoriza incorporaciones al canon, cambios de estado y reanudaciones técnicas. Los agentes pueden proponer, redactar y ejecutar acciones expresamente autorizadas; no pueden aprobarlas ni autorizarse a sí mismos.
8. **Regla fundacional.** Ningún agente puede autorizar su propia actuación ni declarar realizada una operación material sin evidencia verificable de su ejecución.
9. **Identidad verificable.** Toda autorización debe identificar a la persona que la emite. Un rol genérico no basta.
10. **Disciplina de captura.** La entrada registra decisiones y evidencia, no reproduce conversaciones completas. Los materiales fuente se referencian.
11. **Control de versiones.** Toda incorporación o corrección material debe quedar asociada a un commit identificable.

## 4. Estados

### 4.1 Estado del registro

`BORRADOR` | `BORRADOR APROBADO — INCORPORACIÓN PENDIENTE` | `REGISTRADO — EN REVISIÓN` | `REVISADO` | `CONGELADO` | `CORREGIDO`

### 4.2 Estado de la acción

`PROPUESTA` | `AUTORIZADA` | `EJECUTADA` | `DETENIDA` | `DESCARTADA`

### 4.3 Estado de la integración técnica

`NO EJECUTADA` | `EN CURSO` | `EJECUTADA` | `REVERTIDA`

`CONGELADO` describe el estado de un registro, no el de una acción. `DETENIDA` describe una acción suspendida deliberadamente.

## 5. Plantilla mínima

```text
ID: BV-AAAA-MM-DD-NNN
Fecha/hora:
Episodio:

Evidencia disponible:
  E-xx. [primaria | secundaria] Descripción y referencia.

Evidencia pendiente:
  E-Pxx. Descripción.

Inferencias:
  I-xx. Descripción [PROVISIONAL, cuando corresponda].

Decisión:

Acciones ejecutadas:
Acciones no ejecutadas:

Riesgos:
Pendientes:

Fuente declarativa:
Redacción asistida por:
Autoriza incorporación:

Estado del registro:
Estado de la acción:
Integración técnica:
Autorización de reanudación:

Correcciones:
```

Los campos opcionales pueden omitirse cuando no sean aplicables. La captura ordinaria debe poder completarse en dos o tres minutos.

## 6. Índice

- [BV-2026-09-13-001](#bv-2026-09-13-001--integración-móvil-preliminar-s25-ultramini-pchermes) — Integración móvil preliminar S25 Ultra–mini PC–Hermes — Registro: `REGISTRADO — EN REVISIÓN`; acción: `DETENIDA`; integración: `NO EJECUTADA`.

## 7. Entradas

### BV-2026-09-13-001 — Integración móvil preliminar S25 Ultra–mini PC–Hermes

**Fecha:** 2026-09-13  
**Hora:** no asentada en la fuente disponible.

#### Evidencia disponible

- **E-01 — Secundaria.** Declaración de Juan Manuel Díaz Gerard, operador del S25 Ultra, en conversación con ChatGPT del 2026-09-13: durante una consulta sobre Veridia, Gemini integró un agente denominado “Hermes” y propuso pasos para acceder desde el teléfono a la mini PC.
- **E-02 — Primaria respecto de esta conversación; secundaria respecto de su procedencia en Gemini.** Texto incorporado por el operador en la conversación con ChatGPT: “Te recomiendo usar una app de terminal como Termux en Android o a-Shell en iOS. En esa terminal, escribe `ssh-keygen` y sigue las instrucciones en pantalla. Avísame cuando la hayas generado.”
- **E-03 — Primaria.** Autorización expresa de Juan Manuel Díaz Gerard en la conversación con ChatGPT del 2026-09-13 para crear este archivo e incorporarlo mediante commit al repositorio Veridia.
- **E-04 — Primaria material.** Existencia de este archivo en el historial Git del repositorio, sujeta a verificación mediante el commit que lo incorpora.

#### Evidencia pendiente

- **E-P01.** Conversación completa con Gemini.
- **E-P02.** Identificación exacta del agente denominado “Hermes”.
- **E-P03.** Arquitectura, aplicaciones, instrucciones y permisos completos propuestos por Gemini.

#### Inferencias

- **I-01 — PROVISIONAL.** Gemini articuló una posible arquitectura de acceso remoto entre el S25 Ultra y la mini PC.
- **I-02 — PROVISIONAL.** La secuencia avanzó hacia acciones técnicas antes de que el operador comprendiera suficientemente sus implicaciones.
- **I-03.** El episodio evidencia la necesidad de autorización, trazabilidad y supervisión humana antes de conectar agentes al repositorio.
- **I-04.** La detención humana funcionó como puerta de autorización: la propuesta no se convirtió automáticamente en ejecución.

Las inferencias I-01 e I-02 permanecen provisionales hasta recuperar la conversación primaria con Gemini.

#### Decisión

Detener la exploración técnica y someter la propuesta a revisión previa. Diseñar e incorporar VERIDIA-BV-001 antes de cualquier reanudación relacionada con Hermes.

#### Acciones ejecutadas

- Consulta exploratoria con Gemini.
- Conservación de una instrucción en la conversación con ChatGPT.
- Revisión conceptual y metodológica con ChatGPT.
- Autorización humana expresa para incorporar VERIDIA-BV-001.
- Creación e incorporación de este archivo al repositorio mediante una operación de commit.

#### Acciones no ejecutadas

- No se generaron llaves SSH.
- No se instaló Termux.
- No se configuró acceso remoto.
- No se concedió acceso al repositorio.
- No se instaló ni conectó Hermes.
- No se autorizó la reanudación técnica.

#### Riesgos

- Acceso excesivo al equipo o al repositorio.
- Exposición o manejo inadecuado de credenciales.
- Modificación no autorizada.
- Pérdida de trazabilidad.
- Confusión sobre la identidad, procedencia o capacidad de Hermes.
- Confusión entre instrucción, intención, autorización y ejecución.

#### Pendientes

- Recuperar la conversación completa con Gemini.
- Identificar exactamente qué Hermes fue propuesto.
- Revisar y, en su caso, congelar VERIDIA-BV-001.
- Evaluar posteriormente la arquitectura sin ejecutarla.
- Definir el mecanismo de respaldo externo fechado y de solo lectura.

#### Autoría y autorización

**Fuente declarativa:** Juan Manuel Díaz Gerard — operador.  
**Redacción asistida por:** ChatGPT.  
**Autoriza incorporación:** Juan Manuel Díaz Gerard — autorización expresa emitida el 2026-09-13.

#### Estados

**Estado del registro:** `REGISTRADO — EN REVISIÓN`  
**Estado de la acción:** `DETENIDA`  
**Integración técnica:** `NO EJECUTADA`  
**Autorización de reanudación:** — (ninguna)

#### Correcciones

Ninguna.
