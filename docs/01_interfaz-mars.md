# Interfaz MARS

## 1. Barra de menú y barra de herramientas

### Menús principales

![Image](https://www.d.umn.edu/~gshute/mips/Mars/screenshots/execute-tab.png)

![Image](https://www.d.umn.edu/~gshute/mips/Mars/screenshots/editor-settings.png)

![Image](https://i.sstatic.net/6m4Km.png)

![Image](https://www.d.umn.edu/~gshute/mips/Mars/screenshots/settings.png)

![Image](https://www.researchgate.net/publication/328735493/figure/fig1/AS%3A689407921242112%401541379065287/Figura-1-Menu-tools-do-MARS-com-destaque-para-o-MOSS-Assim-como-em-todo-SO-o-elemento.ppm)

![Image](https://hwlabnitc.github.io/assets/mips1-image-0093.DIct3pP6.png)

* **File**: Opciones típicas: *New* (nuevo archivo), *Open…* (abrir archivo ASM), *Save / Save As…*, *Dump Memory…*, *Print…*, *Exit*.
* **Edit**: Operaciones de edición de código: *Undo/Redo*, *Cut/Copy/Paste*, *Find/Replace…*, *Select All*.
* **Run**: Comandos de ensamblado y ejecución del programa: *Assemble* (ensamblar), *Go* (ejecutar hasta el final o hasta pausa), *Step* (ejecutar instrucción a instrucción), *Backstep*, *Pause*, *Stop*, *Reset*.
* **Settings**: Opciones de configuración del entorno: ver panel de etiquetas (“Show Labels Window”), argumentos de programa, mostrar direcciones en hexadecimal, inicializar contador de programa, permitir instrucciones pseudo (“Permit extended (pseudo) instructions and formats”), editor, resaltado, configuración de memoria, etc. ([Ciencias de la Computación][1])
* **Tools**: Herramientas adicionales para simulación avanzada: *Data Cache Simulator*, *Floating Point Representation*, *Instruction Counter*, *MIPS X-Ray*, etc. ([Inf.ufpr][2])
* **Help**: Ayuda general, información de la versión, manuales, etc.

### Barra de herramientas rápida

Justo debajo de los menús aparece una fila de íconos (nuevo archivo, abrir, guardar, ensamblar, ejecutar, etc.). Su función es ofrecer acceso rápido a las opciones más usadas del menú *File/Run/Edit*.
La documentación indica que “Most menu items have equivalent toolbar icons”. ([Scribd][3])
También aparece un control deslizante (“Run speed at max (no interaction)”) que permite ajustar la velocidad de ejecución del programa.

## 2. Panel editor / código fuente (“Text Segment”)

![Image](https://i.imgur.com/8O30Hzh.png)

![Image](https://i.ytimg.com/vi/wDmmRxpMf5E/maxresdefault.jpg)

![Image](https://asm-editor.specy.app/images/ASM-editor.webp)

![Image](https://windows-cdn.softpedia.com/screenshots/Vollmar-MARS_2.png)

![Image](https://i.ytimg.com/vi/22xEtqRivxg/hq720.jpg?rs=AOn4CLBfX2DdpAA4CI1LPoYNOsRdAvB7kg\&sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AGcCYAC0AWKAgwIABABGGUgZShlMA8%3D)

![Image](https://i.stack.imgur.com/tk0uJ.png)

* Es el área donde escribes tu programa en lenguaje ensamblador MIPS (.asm).
* Cuenta con resaltado de sintaxis y números de línea (en versiones recientes). ([Scribd][3])
* Cuando se ensambla, las instrucciones se muestran junto con su dirección de memoria (por ejemplo 0x00400000) y un código básico o traducción básica. Esto facilita ver qué instrucción corresponde a qué dirección.
* Permite editar, cortar, pegar, deshacer, rehacer etc. (como cualquier editor de código) desde el menú Edit.

## 3. Panel de ejecución / vista del programa (“Execute” tab)

![Image](https://minnie.tuhs.org/CompArch/Labs/Figs/mars2.jpg)

![Image](https://minnie.tuhs.org/CompArch/Labs/Figs/mars1.png)

![Image](https://i.stack.imgur.com/4wact.png)

![Image](https://i.stack.imgur.com/tk0uJ.png)

* Cuando ensamblas exitosamente tu programa, cambia a la pestaña *Execute*. Ahí se muestran tres sub-paneles típicamente:

  * *Text Segment Contents*: Las instrucciones ensambladas, con dirección, código máquina, y fuente.
  * *Data Segment Contents*: La memoria de datos, con direcciones, valores en formato hexadecimal, etc.
  * *Registers / Coproc 1 / Coproc 0*: A la derecha, los registros del procesador.
    ([Ciencias de la Computación MSU][4])
* En este modo puedes correr, paso a paso, pausar, reiniciar, etc., para simular la ejecución de tu código.
* Se puede cambiar entre mostrar valores como decimal o hexadecimal, tanto en memoria como en registros. ([Ciencias de la Computación MSU][4])

## 4. Panel de registros (a la derecha)

![Image](https://minnie.tuhs.org/CompArch/Labs/Figs/mars3.jpg)

![Image](https://i.sstatic.net/fo5qy.png)

![Image](https://i.stack.imgur.com/Qr0Q0.png)

![Image](https://marz.utk.edu/wp-content/uploads/2020/05/mars_output_simple_mul_add.png)

* Ubicado típicamente al lado derecho de la ventana principal.
* Muestra una lista de los registros: $zero, $at, $v0, $v1, $a0-$a3, $t0-$t9, $s0-$s7, $k0, $k1, $gp, $sp, $fp, $ra, hi, lo, pc. ([E-Campus][5])
* Permite **editar directamente** los valores de los registros (como en una hoja de cálculo) para simular distintos estados. ([Ciencias de la Computación MSU][4])
* Los valores cambian en tiempo real o al paso del programa.
* Tabs adicionales “Copro 1” y “Copro 0” permiten ver registros de coprocesadores (por ejemplo, punto flotante) si el programa los usa.

## 5. Panel de memoria de datos (“Data Segment”)

![Image](https://i.ytimg.com/vi/wDmmRxpMf5E/maxresdefault.jpg)

![Image](https://wilkinsonj.people.charleston.edu/MARS-data-seg-1.jpg)

![Image](https://i.ytimg.com/vi/Gg7BAe4L5qg/hq720.jpg?rs=AOn4CLAIlgOaEepmmaF9AUwvSLktNkGg4g\&sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AH-CYAC0AWKAgwIABABGGUgZShlMA8%3D)

![Image](https://minnie.tuhs.org/CompArch/Labs/Figs/mars3.jpg)

* Bajo la sección de ejecución, se muestra la memoria de datos del programa: direcciones, valores en esa dirección (y siguientes +4, +8, etc.).
* Permite navegar por la memoria: botones “next/previous”, seleccionar segmento global, pila, etc. ([KFUPM Faculty][6])
* Los valores pueden mostrarse en hexadecimal o decimal. También hay opción ASCII para interpretar valores.
* Facilita ver cómo se cargan/almacenan datos (por ejemplo con instrucciones `lw`, `sw`, etc).

## 6. Ventana de mensajes y entrada/salida (“Mars Messages / Run I/O”)

![Image](https://i.sstatic.net/xqPig.png)

![Image](https://i.sstatic.net/CTt7n.png)

![Image](https://i.ytimg.com/vi/Wyx5wUXG-i0/maxresdefault.jpg)

![Image](https://i.sstatic.net/Kusc2.png)

* Normalmente en la parte inferior de la interfaz, hay una pestaña que alterna entre “Mars Messages” y “Run I/O”.
* **Mars Messages**: Muestra el resultado del ensamblado (si hay errores o advertencias), información de ejecución, pausas, breakpoints, etc. ([Inf.ufpr][2])
* **Run I/O**: Muestra la entrada que el programa solicita al usuario (por ejemplo mediante `syscall` para leer un entero) y la salida que genera (imprimir valores, texto, etc). Durante la ejecución, si el programa solicita entrada, el foco cambia a esta pestaña. ([Inf.ufpr][2])
* Tiene un botón “Clear” para limpiar la ventana de mensajes.

## 7. Segmentos de código y datos: “Text Segment” y “Data Segment”

Como ya se mencionó, el editor + ejecución presentan los dos segmentos principales de un programa MIPS: el segmento de código (texto) y el segmento de datos.

* **Text Segment**: Contiene la sección `.text`, es decir, las instrucciones del programa.
* **Data Segment**: Contiene la sección `.data`, es decir, variables, constantes, arreglos, etc. En MARS puedes ver ambas en la vista de ejecución.
  Solo recordando que en MARS la dirección de inicio de .text es típicamente `0x00400000`, y el .data `0x10010000`. ([Inf.ufpr][2])

## 8. Uso de botones de control de ejecución

Desde el menú Run o la barra de herramientas, los botones permiten controlar la simulación:

* **Assemble**: Ensambla el código fuente. Si hay errores, aparecen en Messages.
* **Go**: Ejecuta completamente el programa (hasta que termine o encuentre un breakpoint).
* **Step**: Ejecuta una instrucción a la vez.
* **Backstep**: Retrocede una instrucción (útil para depuración).
* **Pause / Stop**: Pausar o detener la ejecución.
* **Reset**: Reinicia el estado del programa (registros, memoria) para volver a ejecutar.
* **Run Speed Slider**: Ajusta la velocidad de ejecución (ej: desde lento para ver paso a paso hasta “max” sin interacción).

## 9. Otras funciones importantes / configuración

* En **Settings → Memory Configuration…** puedes ajustar cómo MARS gestiona la memoria simulada (tamaños, zonas, direcciones base).
* En **Settings → Editor…** puedes cambiar fuente, resaltado de sintaxis, indentación, etc.
* En **Settings** puedes escoger si los valores se muestran en hexadecimal, si el programa se ensambla automáticamente al abrir, permitir pseudo-instrucciones, etc.
* En **Tools**, las herramientas extra permiten: simular caché de datos, ver estadísticas de instrucciones, ver representación de punto flotante, etc. Estas herramientas aprovechan la simulación de MIPS para propósitos educativos. ([Inf.ufpr][2])

## 10. Flujo típico de uso

1. Abrir MARS → File → New → escribir tu programa en ensamblador.
2. Guardar el archivo (.asm).
3. Ensamblar (Assemble) el programa. Verificar que no haya errores en Mars Messages.
4. Cambiar a pestaña Execute. Ver los segmentos de texto y datos, registros.
5. Ajustar velocidad (slider) si quieres ver paso a paso.
6. Hacer *Go* o *Step* para ejecutar. Observar cambios en registros o memoria, ver la salida en Run I/O.
7. Si deseas, editar valores en registros/memoria manualmente para probar escenarios.
8. Usar Tools si quieres analizar comportamiento más profundo (por ejemplo caché).
9. Reiniciar (Reset) y repetir según sea necesario.

[1]: https://cs.slu.edu/~fritts/CSCI140_F12/schedule/MARS%20Tutorial.pdf "MARS Tutorial"
[2]: https://www.inf.ufpr.br/hexsel/ci210/assembly/MARS_Tutorial.pdf "MSU CSC 285, Fall 2006"
[3]: https://www.scribd.com/document/573424757/lab-1-to-6-of-mips-assembly-language "MIPS Assembly Basics with MARS | PDF | Menu (Computing)"
[4]: https://computerscience.missouristate.edu/mars-mips-simulator.htm "MARS MIPS Assembler and Runtime Simulator"
[5]: https://courses.e-ce.uth.gr/CE134/resources/MARS_UserGuide.pdf "Registers Instruction Set Directives"
[6]: https://faculty.kfupm.edu.sa/COE/aimane/coe301/tools_manuals/MARS.pdf "An Education-Oriented MIPS Assembly Language Simulator"
