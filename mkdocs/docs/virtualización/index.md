# Máquina Virtual vs Contenedor

!!! Definición

    La virtualización es un proceso que permite a una computadora compartir sus recursos de hardware con varios entornos separados de forma digital. Cada entorno virtualizado se ejecuta dentro de los recursos asignados, como la memoria, la potencia de procesamiento y el almacenamiento.

## Máquinas Virtuales

Las máquinas virtuales dependen

### Bare-metal Hypervisor

![Bare Metal Hypervisor Architecture](./assets/bare-metal-hypervisor.png#only-dark){ align=right }
![Bare Metal Hypervisor Architecture](./assets/bare-metal-hypervisor-white.png#only-light){ align=right }

El hipervisor Tipo 1, también conocido como bare-metal, se ejecuta directamente sobre el hardware físico del servidor, sin necesidad de un sistema operativo anfitrión. Esto lo hace altamente eficiente, ya que tiene acceso directo a los recursos del hardware (CPU, memoria, almacenamiento), lo que reduce la sobrecarga y mejora el rendimiento de las máquinas virtuales (VMs). Ejemplos de hipervisores Tipo 1 incluyen VMware ESXi, Microsoft Hyper-V (cuando se instala directamente en el hardware) y Xen.

Este tipo de hipervisor es ideal para entornos empresariales y centros de datos, donde el rendimiento y la escalabilidad son críticos. Al no depender de un sistema operativo base, es más seguro y estable, ya que reduce la superficie de ataque y los posibles puntos de fallo. Sin embargo, su configuración y gestión pueden ser más complejas que las de un hipervisor Tipo 2, ya que requiere hardware compatible y conocimientos más avanzados.


### Hosted Hypervisor

![Hosted Hypervisor Architecture](./assets/hosted-hypervisor.png#only-dark){ align=right }
![Hosted Hypervisor Architecture](./assets/hosted-hypervisor-white.png#only-light){ align=right }

El hipervisor Tipo 2, o hosted, se instala como una aplicación dentro de un sistema operativo anfitrión (como Windows, Linux o macOS). Esto significa que depende del SO base para gestionar los recursos del hardware, lo que introduce una capa adicional de overhead y puede afectar al rendimiento de las máquinas virtuales. Ejemplos comunes son Oracle VirtualBox, VMware Workstation y Parallels Desktop.

Este tipo de hipervisor es más adecuado para entornos de desarrollo, pruebas o uso personal, donde la facilidad de uso y la flexibilidad son más importantes que el máximo rendimiento. Aunque es menos eficiente que un hipervisor Tipo 1, es más sencillo de configurar y utilizar, ya que no requiere hardware especializado. Sin embargo, al depender de un sistema operativo anfitrión, puede ser más vulnerable a problemas de seguridad y inestabilidad si el SO base falla o es comprometido.

## Contenedores

![Docker Engine Achitecture](./assets/docker-engine.png#only-dark){ align=right }
![Docker Engine Achitecture](./assets/docker-engine-white.png#only-light){ align=right } 

Los contenedores son una forma de virtualización ligera que permite empaquetar una aplicación junto con sus dependencias (bibliotecas, configuraciones, etc.) en una unidad aislada y portable. A diferencia de las máquinas virtuales (VMs), los contenedores no requieren un sistema operativo completo para cada instancia, sino que comparten el kernel del sistema operativo anfitrión, lo que los hace mucho más eficientes en uso de recursos y tiempo de arranque. Esto los hace ideales para entornos de desarrollo, despliegue ágil (DevOps) y escalado rápido de aplicaciones.

La tecnología de contenedores se basa en características del kernel de Linux como namespaces (para aislamiento de procesos) y cgroups (para limitación de recursos). Esto permite que múltiples contenedores se ejecuten de manera aislada en un mismo sistema sin interferir entre sí. Herramientas como Docker, Podman y Kubernetes han popularizado este enfoque, facilitando la creación, distribución y gestión de contenedores a gran escala.
