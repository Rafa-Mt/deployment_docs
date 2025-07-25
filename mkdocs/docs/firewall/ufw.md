# UFW

UFW (Uncomplicated Firewall) es una herramienta diseñada para facilitar la configuración de un firewall en sistemas basados en Linux. Permite gestionar reglas de acceso de manera sencilla, ayudando a proteger el servidor de accesos no autorizados.

## Instalación

Para instalar UFW en Debian/Ubuntu:

```bash
sudo apt update
sudo apt install ufw
```

## Comandos básicos

- Activar UFW:
  ```bash
  sudo ufw enable
  ```
- Ver el estado y reglas:
  ```bash
  sudo ufw status verbose
  ```
- Permitir acceso por puerto (ejemplo: SSH):
  ```bash
  sudo ufw allow 22/tcp
  ```
- Denegar acceso por puerto:
  ```bash
  sudo ufw deny 80/tcp
  ```
- Desactivar UFW:
  ```bash
  sudo ufw disable
  ```

## Configuración básica

Permitir solo SSH, HTTP y HTTPS:

```bash
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```