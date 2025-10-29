# Documentación técnica

## 1. Instalación y **uso desde terminal**

### 1.1. Qué es y qué necesito

- MARS es un **JAR ejecutable** escrito en Java; ensambla y simula programas MIPS desde **CLI** o desde su **IDE**. La ayuda oficial indica que **puedo usarlo por línea de comandos** y detalla las opciones disponibles. ([dpetersanderson.github.io][1])

- El proyecto es **legado** (útil pero sin mantenimiento activo), lo que me ayuda a anticipar diferencias en plataformas modernas. ([Ciencias de la Computación MSU][2])

### 1.2. Compatibilidad de Java (práctica hoy)

- Históricamente MARS “requiere al menos JRE 1.5”. En la práctica, yo puedo ejecutarlo con **JRE/JDK modernos (8–21)**; en macOS, el paquete de Homebrew “mars” (4.5.1) declara **Java 9+** y recomienda Temurin (OpenJDK). Si tengo fuentes HiDPI, también se recomienda Java 9+ por el escalado. ([dpetersanderson.github.io][3])

### 1.3. Descarga

- Descargo **Mars4_5.jar** del sitio del proyecto o empaquetado por terceros (p. ej., Homebrew en macOS). ([Ciencias de la Computación MSU][2])

### 1.4. Ejecución básica del JAR

- Abrir la GUI:

  ```bash
  java -jar Mars4_5.jar
  ```

  (MARS también acepta el nombre `mars.jar` según la ayuda oficial). ([dpetersanderson.github.io][1])

- Ensamblar y **ejecutar sin GUI** (modo batch):

  ```bash
  java -jar Mars4_5.jar programa.asm
  ```

  (Ejecuto desde terminal; útil para automatización/CI). ([dpetersanderson.github.io][1])

### 1.5. Opciones de línea de comandos (las más útiles)

La forma general es:

```bash
java -jar mars.jar [opciones] programa.asm [más.asm ...] [ pa arg1 [más args...] ]
```

Yo puedo combinar opciones; las más valiosas para integración y pruebas son:

- `a` – **ensamblar sin simular** (solo chequeo y generación interna).
- `p` – modo **proyecto**: ensamblo **todos** los `.asm/.s` del directorio junto con el principal.
- `sm` – iniciar ejecución en la etiqueta global `main` si existe.
- `np` – **no permitir** pseudo-instrucciones/formatos extendidos (para forzar ISA estricta).
- `ic` – mostrar **conteo de instrucciones** ejecutadas (útil para medir calidad del código generado).
- `mc <Default|CompactDataAtZero|CompactTextAtZero>` – configuración de memoria.
- `dump <segmento|rango> <formato> <archivo>` – **volcar memoria** (`.text`, `.data` o rango `m-n`) en `Binary|HexText|BinaryText|AsciiText`.
- `me` – enviar **mensajes de MARS a stderr** (separo salida del programa en stdout).
- `ae n` / `se n` – terminar MARS con **código de salida `n`** si hay error de **ensamblado**/de **simulación** (crítico para CI).
- `nc` – no mostrar copyright (limpio al redirigir).
- `dec|hex|ascii` – formato de salida para mem/reg.
- `N` (número) – **máximo de pasos** a simular (corto bucles infinitos).
- `$reg` o `reg_name` – imprimir al final el contenido de registros especificados.
- `m-n` – imprimir al final rango de memoria.
- `pa` – **pasar argumentos** al programa (disponibles en `$a0/$a1` estilo `argc/argv`). ([dpetersanderson.github.io][1])

**Ejemplos oficiales que yo uso a diario:**

```bash
# 1) Solo ensamblar
java -jar Mars4_5.jar a fibonacci.asm

# 2) Ensamblar y ejecutar, mostrando $s0 y $s1 al final
java -jar Mars4_5.jar $s0 $s1 0x10010000-0x10010010 fibonacci.asm

# 3) Ensamblar todo el directorio como "proyecto"
java -jar Mars4_5.jar p principal.asm

# 4) Volcar .text (código máquina) a HexText sin simular
java -jar Mars4_5.jar a dump .text HexText hexcode.txt fibonacci.asm

# 5) Ejecutar con tope de 100k pasos
java -jar Mars4_5.jar 100000 infinite.asm

# 6) Pasar argumentos a un programa (argc/argv)
java -jar Mars4_5.jar t0 process.asm pa counter 10
```

([dpetersanderson.github.io][1])

---

## 2. **Uso en cursos de compiladores**: integrar mi backend con MARS

### 2.1. Flujo “compilador → ensamblador MIPS → simulación”

1. **Mi compilador** traduce a **MIPS assembly** (`.s`/`.asm`).
2. Invoco MARS en modo **batch** (`a` para validar o ejecución directa).
3. **Recojo**:

   - **Código de salida** (éxito/fracaso) con `ae`/`se`.
   - **stdout** (salida del programa MIPS).
   - **stderr** (mensajes de MARS con `me`).
   - **volcados** (`dump`) para comparar memoria o código máquina. ([dpetersanderson.github.io][1])

### 2.2. Ejecución automática de casos de prueba

Yo preparo un script (ejemplo Bash) que:

- compila mi lenguaje a `.asm`,
- corre MARS,
- compara contra oráculos, y
- produce métricas (instrucciones, integridad de registros, etc.).

```bash
#!/usr/bin/env bash
set -euo pipefail

SRC="$1"                    # fuente en mi lenguaje
ASM="${SRC%.lang}.asm"      # salida MIPS
OUT="${SRC%.lang}.out"
REF="${SRC%.lang}.ref"

# 1) Generar MIPS
./mi_compilador "$SRC" > "$ASM"

# 2) Ensamblar y ejecutar con MARS en modo batch
#    - sm: empieza en 'main'
#    - me: mensajes de MARS a stderr
#    - ic: cuenta de instrucciones
#    - se 2: si hay error en ejecución, salir con 2
java -jar Mars4_5.jar sm ic me se 2 "$ASM" >"$OUT"

# 3) Comparar con salida esperada
diff -u "$REF" "$OUT"
echo "OK: $SRC"
```

(El uso de `se`/`ae` permite fallar el CI si ocurre un error de simulación/ensamblado). ([dpetersanderson.github.io][1])

### 2.3. Casos de prueba deterministas

Cuando necesito reproducibilidad (aleatoriedad o I/O), yo:

- fijo semillas con syscall **Set seed (40)** y uso syscalls **random** (41–44). ([dpetersanderson.github.io][4])
- redirijo I/O: `me` para separar mensajes de MARS y `stdin/stdout` para la app. ([dpetersanderson.github.io][1])
- fuerzo **sin pseudo-instrucciones** con `np` si evalúo “calidad de backend” frente a la ISA base. ([dpetersanderson.github.io][1])

## 3. **Ejemplos completos**

### 3.1. Teórico (patrones de backend)

**Llamadas a función y uso de pila**
Como generador de código, yo debo:

- preservar `$s0–$s7` si los uso (callee-saved),
- pasar arg. en `$a0–$a3`,
- devolver en `$v0/$v1`,
- mantener `$sp` alineado a palabra,
- guardar `$ra` si haré `jal`.
  (Estos lineamientos son estándar y se reflejan en la depuración con registros/segmentos de MARS). ([dpetersanderson.github.io][3])

**Estrategias que aplico en MARS:**

- Si quiero medir eficiencia del código del compilador, activo `ic` (conteo de instrucciones). ([dpetersanderson.github.io][1])
- Para revisar el **código máquina** que genero, uso `dump .text HexText`. ([dpetersanderson.github.io][1])

### 3.2. Práctico 1 — “Hola mundo” con argumentos (y prueba automatizada)

**Programa (`hello.asm`)**

```asm
        .data
msg:    .asciiz "Hola, "
nl:     .asciiz "\n"

        .text
        .globl main
main:
        # argc ($a0) y argv ($a1) llegan desde 'pa' si ejecuto por CLI
        li   $v0, 4
        la   $a0, msg
        syscall

        # si argc >= 2, imprimir argv[1]
        move $t0, $a0
        blt  $t0, 2, .no_arg

        lw   $t1, 0($a1)     # argv base (puntero al propio argv[0])
        lw   $a0, 4($a1)     # argv[1]
        li   $v0, 4
        syscall
        b    .end

.no_arg:
        li   $v0, 4
        la   $a0, nl
        syscall

.end:
        li   $v0, 10         # exit
        syscall
```

**Ejecuto con argumentos**:

```bash
java -jar Mars4_5.jar me sm hello.asm
```

(El uso de syscalls 4/10 y paso de argumentos `pa` está definido en la ayuda oficial). ([dpetersanderson.github.io][4])

### 3.3. Práctico 2 — `addi` y depuración paso a paso

```asm
        .text
        .globl main
main:
        li   $t4, 20
        addi $t0, $t4, -30   # $t0 = -10
        li   $v0, 10
        syscall
```

En la **GUI** (pestaña *Execute*) yo activo **breakpoints** y uso **Step/Backstep** para observar:

- cambios en `$t0`,
- PC y flujo,
- memoria y registros en el panel derecho. (Estas características están descritas en *Features/IDE/Debugging*). ([dpetersanderson.github.io][5])

### 3.4. Práctico 3 — Función recursiva `fact(n)` y volcado de memoria

```asm
        .data
fmt:    .asciiz "fact = "
nl:     .asciiz "\n"

        .text
        .globl main
main:
        li   $a0, 5
        jal  fact
        move $t0, $v0

        # imprimir resultado
        li   $v0, 4
        la   $a0, fmt
        syscall
        li   $v0, 1
        move $a0, $t0
        syscall
        li   $v0, 4
        la   $a0, nl
        syscall
        li   $v0, 10
        syscall

# v0 = fact(a0)
fact:
        addiu $sp, $sp, -8
        sw    $ra, 4($sp)
        sw    $a0, 0($sp)

        blez  $a0, .base
        addiu $a0, $a0, -1
        jal   fact
        lw    $a0, 0($sp)
        mul   $v0, $v0, $a0
        b     .ret
.base:
        li    $v0, 1
.ret:
        lw    $ra, 4($sp)
        addiu $sp, $sp, 8
        jr    $ra
```

- Ejecuto y **cuento instrucciones**:

  ```bash
  java -jar Mars4_5.jar sm ic me fact.asm
  ```

- Si quiero inspeccionar la **zona de pila** utilizada (por ejemplo, top de memoria), puedo **volcar un rango** al final:

  ```bash
  java -jar Mars4_5.jar sm dump 0x7fffeffc-0x7ffff03c HexText pila.hex fact.asm
  ```

  (El mecanismo `dump` con rango está en la ayuda oficial). ([dpetersanderson.github.io][1])

### 3.5. Buenas prácticas cuando genero código para MARS

1. **Definir `main` y usar `sm`** para que el arranque sea consistente. ([dpetersanderson.github.io][1])
2. **Separar I/O del simulador** con `me` (stderr) y la salida del programa (stdout). ([dpetersanderson.github.io][1])
3. **Forzar ISA base** (`np`) cuando evalúo el backend sin ayuda de pseudo-ops (útil para rúbricas). ([dpetersanderson.github.io][1])
4. **Versionar volcados** (`dump .text HexText`) para revisar cambios de código-máquina. ([dpetersanderson.github.io][1])
5. **Medir instrucciones** (`ic`) como proxy inicial de eficiencia. ([dpetersanderson.github.io][1])
6. **Configurar memoria** (`mc`) si mis pruebas necesitan segmentos compactos. ([dpetersanderson.github.io][1])
7. **Usar syscalls documentadas**; todas las de SPIM (1–17) y extensiones de MARS (≥30) están listadas. ([dpetersanderson.github.io][4])

## 4. **Errores comunes** (causas y soluciones validadas)

1. **El JAR no abre/da doble clic y no pasa nada**

    - *Causa*: Asociación de archivos o `java` no instalado/en PATH.
    - *Solución*: Ejecutar explícitamente `java -jar Mars4_5.jar` (o instalar Temurin y ajustar PATH). ([Stack Overflow][6])

2. **Texto diminuto en pantallas HiDPI**

    - *Causa*: Java antiguo sin escalado para Swing/AWT.
    - *Solución*: Usar **Java 9+**. ([Hardware Lab NITC][7])

3. **El programa ignora mi `exit2` (syscall 17) cuando uso la GUI**

    - *Causa*: La GUI de MARS **ignora** el valor de `exit2`.
    - *Solución*: En batch, evaluar el código de salida del propio MARS con `se/ae`; en GUI, usar `exit` (10) solo para terminar. ([dpetersanderson.github.io][4])

4. **No encuentro la salida del programa cuando redirijo**

    - *Causa*: Mezcla de mensajes de MARS con stdout.
    - *Solución*: Añadir `me` para que los **mensajes** de MARS vayan a **stderr**; así `stdout` queda limpio. ([dpetersanderson.github.io][1])

5. **Bucle infinito en pruebas automáticas**

    - *Causa*: Error del compilador; sin límite de pasos, la CI se cuelga.
    - *Solución*: Añadir un **límite de pasos** (por ejemplo `100000`). ([dpetersanderson.github.io][1])

6. **Mi backend falla en MARS cuando prohíbo pseudo-ops**

    - *Causa*: Genero `li`, `move`, etc. (pseudo-instrucciones).
    - *Solución*: O permito pseudo-ops, o emito secuencias base (`ori/lui`, `addu $d,$s,$zero`, etc.). `np` me sirve para detectarlo. ([dpetersanderson.github.io][1])

7. **Syscalls incorrectas o registros mal usados**

    - *Causa*: Número de servicio equivocado o argumentos en registros incorrectos.
    - *Solución*: Revisar la **tabla oficial de syscalls** (1–17 SPIM-compatibles; 30+ específicas de MARS). ([dpetersanderson.github.io][4])

8. **El programa no inicia en `main`**

    - *Causa*: No marqué `main` como global o no usé `sm`.
    - *Solución*: `.globl main` + opción `sm`. ([dpetersanderson.github.io][1])

9. **Direcciones/memoria no coinciden con mis pruebas**

    - *Causa*: Configuración de memoria distinta (compacta vs. por defecto).
    - *Solución*: Forzar `mc Default` o el modo específico requerido. ([dpetersanderson.github.io][1])

10. **Necesito el binario del código para otra herramienta**

    - *Causa*: Solo tengo `.asm`.
    - *Solución*: `a dump .text HexText salida.hex archivo.asm` para obtener el **código máquina** en HexText. ([dpetersanderson.github.io][1])

## 5. **Preguntas frecuentes (FAQ)**

1. **¿Puedo integrar MARS en un pipeline de CI?**

    Sí. Yo ejecuto `java -jar Mars4_5.jar` en batch, uso `ae`/`se` para códigos de salida y `me` para separar stderr. ([dpetersanderson.github.io][1])

2. **¿Cómo paso argumentos tipo `argv` a mi programa MIPS?**

    Con `pa`: `java -jar Mars4_5.jar prog.asm pa arg1 arg2`. En tiempo de ejecución, `argc` está en `$a0` y `argv` en `$a1`. ([dpetersanderson.github.io][1])

3. **¿Cómo limito el tiempo de ejecución sin matar procesos?**

    Uso el **límite de pasos**: `java -jar Mars4_5.jar 200000 prog.asm`. ([dpetersanderson.github.io][1])

4. **¿Cómo inspecciono el código máquina generado?**

    Con `dump .text HexText`. ([dpetersanderson.github.io][1])

5. **¿Cómo fuerzo a mi backend a no depender de pseudo-ops?**

    Ejecuto con `np` y verifico fallos/ensamblado; luego ajusto las expansiones (por ejemplo, reemplazar `li` por `lui/ori`). ([dpetersanderson.github.io][1])

6. **¿Cómo arranco siempre en `main` al ejecutar pruebas?**

    Marco la etiqueta y uso `sm`. ([dpetersanderson.github.io][1])

7. **¿Cómo capturo solo la salida del programa para compararla con un oráculo?**

    Redirijo stdout a un archivo y envío mensajes de MARS a stderr con `me`. ([dpetersanderson.github.io][1])

8. **¿Cómo simulo entrada del usuario en modo batch?**

    Redirijo stdin: `java -jar Mars4_5.jar prog.asm < input.txt`. Los syscalls 5/8 leen de stdin. ([dpetersanderson.github.io][4])

9. **¿Cómo mido la “cantidad de trabajo” de mi código?**

    Actívese `ic` para mostrar **conteo de instrucciones** ejecutadas. ([dpetersanderson.github.io][1])

10. **¿Qué Java instalo hoy para evitar problemas visuales o de ejecución?**
  
    Instalo **Temurin 17/21** y corro `java -jar Mars4_5.jar`. En macOS, Homebrew indica **Java 9+** y ofrece Temurin fácilmente. ([Homebrew Formulae][8])

11. **¿MARS soporta herramientas externas o “devices”?**

    Sí, MARS tiene el concepto de **Tools** que interactúan vía **MMIO** (memoria mapeada), útiles para prácticas avanzadas. ([dpetersanderson.github.io][5])

12. **¿Dónde encuentro la tabla de syscalls y notas de compatibilidad con SPIM?**

    En la **ayuda oficial** de MARS (syscalls 1–17 compatibles con SPIM; 30+ exclusivas). ([dpetersanderson.github.io][4])

## Referencias

- **Ayuda oficial MARS 4.5 – Introducción y contexto** (Java requerido, visión general y estado “legacy”). ([dpetersanderson.github.io][3])
- **Ayuda oficial – Uso por línea de comandos** (formato y **todas las opciones** con ejemplos). ([dpetersanderson.github.io][1])
- **Ayuda oficial – Syscalls** (tabla completa, notas y ejemplos). ([dpetersanderson.github.io][4])
- **Sitio del proyecto – Features** (características de IDE, depuración, tools/MMIO). ([dpetersanderson.github.io][5])
- **Página de Homebrew “mars”** (versión 4.5.1, **Java 9+** recomendado/Temurin). ([Homebrew Formulae][8])

[1]: https://dpetersanderson.github.io/Help/MarsHelpCommand.html "MARS 4.5 help contents"
[2]: https://computerscience.missouristate.edu/mars-mips-simulator.htm "MARS MIPS Assembler and Runtime Simulator"
[3]: https://dpetersanderson.github.io/Help/MarsHelpIntro.html "MARS 4.5 help contents"
[4]: https://dpetersanderson.github.io/Help/SyscallHelp.html "MIPS syscall functions available in MARS"
[5]: https://dpetersanderson.github.io/features.html "MARS MIPS simulator"
[6]: https://stackoverflow.com/questions/40563242/execute-and-get-the-output-from-a-mips-file-mars-environment-in-java "Execute and get the output from a MIPS file (Mars ..."
[7]: https://hwlabnitc.github.io/MIPS/mips_setup "MIPS Setup - Hardware Lab NITC"
[8]: https://formulae.brew.sh/cask/mars "mars"
