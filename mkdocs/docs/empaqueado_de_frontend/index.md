# Vite

Es una herramienta de construcción que proporciona dos servicios:

- Un servidor de desarrollo que ofrece [Hot Module Replacement (HMR)](https://es.vite.dev/guide/features#hot-module-replacement).
- Un empaquetador de producción que genera archivos estáticos optimizados usando [Rollup](https://rollupjs.org/).

## Vite vs Webpack

Vite es notablemente más rápido que otros bundlers tradicionales como Webpack, especialmente durante el desarrollo, debido a varias razones fundamentales en su arquitectura y enfoque:

- **Uso de ES Modules**: Vite aprovecha la capacidad de los navegadores modernos para cargar módulos ES de forma nativa. Esto significa que durante el desarrollo, Vite sirve los archivos directamente al navegador "on-demand" (bajo demanda), sin la necesidad de un paso de bundling completo. Esto reduce drásticamente los tiempos de inicio del servidor de desarrollo.
- **Hot Module Replacement (HMR) eficiente**: Vite implementa HMR de manera más eficiente al actualizar solo los módulos que han cambiado, en lugar de recargar toda la aplicación. 
- **Uso de Rollup**: En producción, Vite utiliza Rollup para empaquetar los archivos, el cual implementa optimizaciones avanzadas como tree-shaking y code-splitting, lo que resulta en archivos finales más pequeños y rápidos de cargar.