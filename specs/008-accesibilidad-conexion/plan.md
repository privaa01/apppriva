# Implementation Plan: F08 — Lectura accesible y recuperación de conexión

**Branch**: `work` | **Date**: 2026-11-09 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/008-accesibilidad-conexion/spec.md`

## Summary

F08 incorpora cuatro tamaños globales de texto seleccionables desde Perfil y recordados
en el dispositivo, además de un aviso de desconexión y reintento manual para operaciones
remotas. La solución añade un controlador de accesibilidad en la raíz de Flutter,
persiste únicamente el identificador de la escala con `shared_preferences` y reutiliza
`connectivity_plus` para observar disponibilidad de interfaz. Tips y Zyro no se bloquean
porque su contenido es local; no se crean colas ni reenvíos automáticos.

## Technical Context

**Language/Version**: Dart `>=3.13.7 <4.0.0`, Flutter compatible con el SDK instalado  
**Primary Dependencies**: Flutter Material 3, `connectivity_plus 7.3.2`, `shared_preferences` como dependencia directa  
**Storage**: preferencia local `priva.text_scale` con un valor no personal; Firestore/Firebase existentes para operaciones remotas  
**Testing**: `flutter analyze`, `flutter test`, pruebas de widgets/controladores y validación manual Android/TalkBack  
**Target Platform**: Android API 24 y API 36, 320×720 y 412×915 dp  
**Project Type**: aplicación móvil Flutter  
**Performance Goals**: aplicar la preferencia antes del primer contenido útil; reflejar un cambio de escala en ≤300 ms; mostrar cambio de conectividad en ≤2 s desde el evento del sistema; mantener interacciones visuales a 60 fps en los recorridos F08  
**Constraints**: cuatro escalas exactas (0.90, 1.00, 1.25, 1.50); sin asociación a cuenta; sin persistir cuestionario; sin reenvío automático; contraste 4.5:1 para texto normal y 3:1 para texto grande y controles  
**Scale/Scope**: raíz de aplicación, Perfil y operaciones remotas de F01–F07; Tips y Zyro local continúan sin red

## Constitution Check

*GATE: aprobado antes de Phase 0 y revalidado después de Phase 1.*

| Principio | Comprobación | Resultado |
| --- | --- | --- |
| I. Spec como fuente | F08 está aprobado y registra cinco decisiones del 2026-11-09. | Pasa |
| II. Privacidad | Solo se guarda una escala no personal, local, sin cuenta ni sincronización. | Pasa |
| III. Cuestionario sin persistencia | El controlador de red no copia respuestas/resultados; el estado sigue solo en RAM. | Pasa |
| IV. Límites de Zyro | No cambia contenido ni capacidades de Zyro; permanece local. | Pasa |
| V. Accesibilidad | Escalas, contraste, TalkBack, matriz Android y criterios operables están definidos. | Pasa |
| VI. Calidad y seguridad | Reintento manual, bloqueo de doble toque y errores sin detalles internos. | Pasa |
| VII. Trazabilidad | Contratos y tareas enlazarán RF-16/RF-17, CA-08.1–3 y RNF. | Pasa |
| VIII. Simplicidad | Un controlador global y reutilización del detector existente; una dependencia directa justificada. | Pasa |
| IX. Gobierno | Spec aprobado; plan y tareas requieren aprobación antes de cerrar entrega. | Pasa |

La enmienda constitucional 1.1.0 limita la plataforma vigente a Android y prevalece
sobre la mención histórica a iOS. Phase 1 no introduce conflictos nuevos.

## Project Structure

### Documentation (this feature)

```text
specs/008-accesibilidad-conexion/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── accessibility-connectivity.md
└── tasks.md
```

### Source Code (repository root)

```text
mobile/
├── lib/
│   ├── app/priva_app.dart
│   ├── features/accessibility/
│   │   ├── application/text_scale_controller.dart
│   │   └── data/text_scale_preferences.dart
│   ├── features/connectivity/
│   │   ├── application/connectivity_controller.dart
│   │   └── presentation/connectivity_notice.dart
│   └── features/profile/presentation/profile_screen.dart
└── test/
    ├── app/
    ├── features/accessibility/
    ├── features/connectivity/
    └── features/profile/
```

**Structure Decision**: conservar la aplicación Flutter única y separar únicamente
los dos servicios transversales. Perfil recibe el controlador de escala por composición;
la raíz aplica `TextScaler.linear` a todo el árbol y expone el estado de red sin acoplar
Tips ni Zyro.

## Design and Delivery Strategy

1. Declarar `shared_preferences` directamente y encapsular su clave y valores.
2. Inicializar la preferencia antes de `runApp`; si está ausente o dañada usar Normal.
3. Aplicar la escala en `MaterialApp.builder` preservando cualquier `builder` de prueba.
4. Añadir en Perfil un grupo accesible de cuatro opciones con selección inmediata.
5. Consolidar la observación de red en un controlador de aplicación compartido.
6. Exponer un aviso accesible solo a flujos remotos; `Reintentar` queda deshabilitado
   sin conexión o mientras la misma operación está en curso.
7. Mantener Tips y Zyro fuera de ese bloqueo y conservar la pausa en RAM de F06.
8. Ejecutar análisis, pruebas automatizadas, matriz Android y aceptación manual.

## Risks and Controls

| Riesgo | Control |
| --- | --- |
| `connectivity_plus` indica interfaz, no acceso real a Internet | Tratarlo como señal preventiva; los repositorios remotos siguen manejando su propio fallo. |
| Escala 150 % produce desbordamientos | Scroll, layouts flexibles y pruebas en las dos resoluciones extremas. |
| Reintento duplica una escritura | Un único callback, botón bloqueado mientras corre y ninguna cola/repetición automática. |
| Preferencia corrupta | Lista cerrada de valores; fallback a Normal sin error visible ni log de datos. |
| Aviso global bloquea contenido local | Aplicarlo solo alrededor de acciones remotas; pruebas explícitas para Tips y Zyro sin red. |

## Complexity Tracking

No hay violaciones constitucionales que requieran excepción.
