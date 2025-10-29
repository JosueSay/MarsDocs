# Documentación técnica por tutorial

## 1. Introducción general

Al trabajar con el simulador **MARS**, yo tengo a mi disposición una herramienta integral para el aprendizaje y la experimentación con el lenguaje ensamblador **MIPS**.
El documento describe paso a paso cómo **descargar, instalar, ejecutar, depurar y analizar programas ensambladores** en este entorno.

MARS fue desarrollado por **Ken Vollmar** y **Pete Sanderson** en Missouri State University.
El simulador combina en una sola aplicación tres componentes clave:

1. Un **editor de texto** con resaltado de sintaxis.
2. Un **ensamblador MIPS** que convierte el código fuente en instrucciones máquina.
3. Un **simulador** que ejecuta el programa y permite observar registros, memoria y E/S.

## 2. Instalación y requisitos del sistema

Para instalar MARS, yo debo:

1. **Descargar el archivo** `Mars4_5.jar` desde:
   [http://courses.missouristate.edu/KenVollmar/MARS/download.htm](http://courses.missouristate.edu/KenVollmar/MARS/download.htm)

2. **Verificar que tengo Java instalado.**
   MARS requiere al menos **Java J2SE 1.4.2** (SDK o posterior).
   Hoy en día puedo usar **Java 8, 11, 17 o 21** sin problemas.
   En sistemas modernos, basta con ejecutar:

   ```bash
   java -jar Mars4_5.jar
   ```

3. Si el archivo `.jar` está correctamente asociado, puedo iniciarlo con doble clic.
   Esto abrirá la **interfaz gráfica de usuario (GUI)** de MARS.

## 3. Exploración de la interfaz de MARS

Una vez iniciado, MARS muestra su interfaz compuesta por varios elementos fundamentales:

### 3.1. El editor

En la pestaña **Edit**, yo puedo:

- Crear archivos nuevos: *File → New*.
- Guardarlos con *File → Save As*.
- Escribir directamente código ensamblador MIPS.

### 3.2. El simulador

Cuando ensamblo un programa (menú *Run → Assemble*), la aplicación cambia a la pestaña **Execute**, donde se muestran:

- El **segmento de texto** (código ensamblado).
- El **segmento de datos** (memoria).
- La lista de **registros** del procesador.
- Las ventanas de **mensajes** y **E/S de ejecución** (Mars Messages y Run I/O).

### 3.3. La barra de herramientas

Contiene los botones de control:

- **Assemble**: ensamblar el código.
- **Go / Run**: ejecutar el programa completo.
- **Step**: ejecutar una instrucción.
- **Backstep**: revertir una instrucción.
- **Pause / Stop / Reset**: controlar la simulación.
- **Speed Slider**: ajustar la velocidad de ejecución.

## 4. Ejemplo base del tutorial

El tutorial incluye el programa `tutorial01.asm`, que muestro aquí de manera íntegra:

```asm
#----------------------------------------------------------- 
# Program File: tutorial01.asm 
# Written by:   Nate Houk 
# Date Created: 1/22/08 
# Description:  Programa introductorio para MARS 
#----------------------------------------------------------- 

.data 
string1: .asciiz  "Welcome to EE 109\n" 
string2: .asciiz  "Assembly language is fun!\n" 
string3: .asciiz  "\nLoop #"

.text 
main: 
    li $v0, 4 
    la $a0, string1 
    syscall 

    la $a0, string2 
    syscall 

    li $t0, 1 
loop: 
    li $v0, 4 
    la $a0, string3 
    syscall 

    li $v0, 1 
    move $a0, $t0 
    syscall 

    addi $t0, $t0, 1 
    bne $t0, 4, loop 

    li  $v0, 10 
    syscall
```

### Análisis

1. Imprime dos mensajes iniciales.
2. Entra en un bucle que muestra tres iteraciones de “Loop #1”, “Loop #2” y “Loop #3”.
3. Finaliza con la syscall 10 (salida del programa).

## 5. Ejecución y simulación paso a paso

### 5.1. Ensamblar el programa

- Desde *Run → Assemble*.
- Si hay errores, se listan en la ventana *Mars Messages*.

### 5.2. Ejecutar

- Desde *Run → Go* o el botón **Go**.
- La salida se visualiza en *Run I/O*:

  ```bash
  Welcome to EE 109
  Assembly language is fun!
  Loop #1
  Loop #2
  Loop #3
  ```

### 5.3. Controlar la ejecución

- Puedo usar los botones de **Step** y **Backstep** para avanzar o retroceder instrucción a instrucción.
- Si mi programa tiene bucles largos, reduzco la velocidad con el **slider** para evitar sobrecargar la CPU.

## 6. Depuración en MARS

El tutorial enfatiza el uso del **depurador visual**:

### 6.1. Breakpoints

Puedo hacer clic en la casilla a la izquierda de una instrucción para marcar un **punto de interrupción** (breakpoint).
Por ejemplo:

```bash
addi $t0, $t0, 1
```

Si ejecuto con *Run*, el simulador se detiene justo antes de esa instrucción.

### 6.2. Inspección de registros

Una vez detenido el programa:

- Reviso los valores de `$t0`, `$a0`, `$v0`, etc.
- Observo el registro **PC (Program Counter)** para ver la instrucción pendiente.

### 6.3. Visualización de memoria

En la sección **Data Segment**, MARS muestra las direcciones y valores de la memoria.
Por ejemplo, si `$a0` apunta a `string3`, puedo localizar en memoria la secuencia ASCII que representa “Loop #”.

Puedo correlacionar cada byte con su carácter usando la tabla ASCII incluida en el tutorial.

## 7. Ejercicio práctico propuesto

El tutorial me invita a realizar una práctica:

1. Quitar el breakpoint previo.
2. Colocar uno nuevo en la instrucción `syscall` antes de imprimir “Loop #”.
3. Ejecutar hasta esa línea y observar el contenido de `$a0` (puntero al texto).
4. Usar la tabla ASCII para ubicar manualmente en la memoria dónde están las letras de “Loop #” o “Welcome”.

De esa forma aprendo:

- A navegar la memoria.
- A comprender direcciones y punteros.
- A relacionar registros con segmentos de datos.

## 8. Errores comunes en el tutorial

1. **No tener Java instalado.**

   MARS no abrirá o mostrará error al ejecutar el `.jar`.

   Solución: instalar JDK 8 o superior.

2. **Olvidar guardar el archivo antes de ensamblar.**

   MARS genera error de ruta o no actualiza el código.

   Solución: usar *File → Save* antes de ensamblar.

3. **Programa en bucle infinito.**

   Causa: error en condiciones de salto (`bne`, `beq`).

   Solución: usar *Reset* o ajustar el slider para frenar la ejecución.

4. **Breakpoints inactivos.**

   Ocurre si se ensambló de nuevo sin limpiar el estado.

   Solución: *Reset* y reensamblar antes de ejecutar.

5. **Ventana Run I/O sin salida.**

   Causa: uso de syscall errónea o argumento nulo en `$a0`.

   Solución: revisar la carga de direcciones con `la $a0, etiqueta`.

## 9. Aplicación del tutorial a proyectos de compiladores

Cuando uso MARS como entorno de **verificación de backends**, este tutorial me sirve para:

- Validar que el ensamblador que genera mi compilador produce **código MIPS funcional**.
- Automatizar pruebas comparando salidas (por ejemplo, con `java -jar Mars4_5.jar archivo.asm`).
- Utilizar los **breakpoints** y el **panel de registros** para verificar la traducción correcta de variables y saltos.

El flujo completo que sigo:

1. Genero un `.asm` con mi compilador.
2. Ensamblo y simulo con MARS.
3. Analizo la correspondencia entre símbolos del lenguaje fuente y registros.
4. Si el resultado difiere, uso la vista de memoria y el PC para depurar la secuencia de instrucciones generadas.

## 10. Conclusión personal

A partir de este tutorial, yo comprendo que MARS no es solo un simulador gráfico sino un **entorno pedagógico completo** para comprender cómo el código ensamblador interactúa con registros, memoria y el ciclo de ejecución.
Me permite practicar tanto la **sintaxis MIPS** como los **conceptos de arquitectura** (segmentos, syscalls, saltos, stack, etc.).

Al dominar el flujo del tutorial (`File → Assemble → Run → Step/Backstep → Debug`), puedo luego extender su uso a:

- pruebas automatizadas,
- integración con compiladores educativos,
- y análisis de rendimiento mediante conteo de instrucciones.

## 11. Referencias utilizadas

1. **MARS Tutorial (Missouri State University)** — documento fuente original incluido en el PDF.
2. **Ken Vollmar & Pete Sanderson, *MARS: A MIPS Assembler and Runtime Simulator***, Missouri State University.
3. **MARS official download site:** [http://courses.missouristate.edu/KenVollmar/MARS](http://courses.missouristate.edu/KenVollmar/MARS)
4. **MARS Help & Syscall Reference** (2024) — documentación oficial distribuida con el `.jar`.
5. **Missouri State University EE 109 course notes** — prácticas con MARS 4.5 (actualizadas a Java 8+).
