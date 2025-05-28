# Universal LEMP Stack Auto-Installer

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Shell](https://img.shields.io/badge/shell-bash-green.svg)
![Platform](https://img.shields.io/badge/platform-linux-lightgrey.svg)
![LEMP](https://img.shields.io/badge/stack-LEMP-orange.svg)

A comprehensive, automated LEMP (Linux, Nginx, MariaDB, PHP) stack installer that works across major Linux distributions. Get your web server environment up and running in minutes with the latest stable versions.

## 🚀 What is LEMP Stack?

**LEMP** is a popular web development stack consisting of:
- **L**inux - Operating System
- **E**ngine-X (Nginx) - Web Server
- **M**ariaDB/MySQL - Database Server  
- **P**HP - Server-side Scripting Language

## Install with One Click 🚀  

Deploy this script effortlessly on your **[MyHBD.net](https://www.myhbd.net)** server with just a single click!  

### Why Choose MyHBD.net?  
✅ High-performance VPS solutions  
✅ Multiple data centers across Europe & Asia  
✅ Reliable and optimized for seamless deployment  

Start now and streamline your server setup with ease!  


## ✨ Features

- **Universal compatibility**: Works across 10+ Linux distributions
- **Latest versions**: Installs the most recent stable versions of all components
- **Automated setup**: One-command installation with zero interaction required
- **Secure by default**: Generates random MariaDB root password
- **Comprehensive logging**: Detailed installation logs with timestamps
- **Production-ready**: Follows best practices and security guidelines
- **Test page included**: Automatically creates PHP info and welcome pages
- **Service management**: Automatically enables and starts all services

## 📋 Supported Operating Systems

| Distribution | Versions | Package Manager | Status |
|--------------|----------|-----------------|--------|
| **Ubuntu** | 18.04, 20.04, 22.04, 24.04+ | APT | ✅ Tested |
| **Debian** | 10, 11, 12+ | APT | ✅ Tested |
| **Linux Mint** | 20, 21+ | APT | ✅ Tested |
| **CentOS** | 7, 8, 9+ | YUM/DNF | ✅ Tested |
| **RHEL** | 8, 9+ | YUM/DNF | ✅ Tested |
| **Fedora** | 37, 38, 39+ | DNF | ✅ Tested |
| **Rocky Linux** | 8, 9+ | DNF | ✅ Tested |
| **AlmaLinux** | 8, 9+ | DNF | ✅ Tested |
| **openSUSE** | Leap 15+ | Zypper | ✅ Tested |
| **Arch Linux** | Rolling | Pacman | ✅ Tested |
| **Manjaro** | Rolling | Pacman | ✅ Tested |

## 🛠️ What Gets Installed

### Nginx (Web Server)
- Latest stable version from official repositories
- Configured and running on port 80
- Auto-start enabled

### MariaDB (Database Server)
- Latest stable MariaDB version
- Secure installation with random root password
- Auto-start enabled
- Password saved to installation log

### PHP (Latest Version)
- **PHP 8.3+** (latest available version)
- Essential extensions included:
  - `php-fpm` - FastCGI Process Manager
  - `php-cli` - Command Line Interface
  - `php-mysql` - MySQL/MariaDB support
  - `php-gd` - Image processing
  - `php-mbstring` - Multi-byte string handling
  - `php-xml` - XML processing
  - `php-curl` - URL handling
  - `php-zip` - Archive handling
  - `php-bcmath` - Arbitrary precision mathematics
  - `php-intl` - Internationalization

## 🔧 Prerequisites

- Linux-based operating system (see supported distributions)
- Root privileges (sudo access)
- Active internet connection
- Minimum 1GB RAM (2GB+ recommended)
- At least 2GB free disk space

## 📥 Quick Installation

### One-Line Install (Recommended)

```bash
# Download and run the installer
curl -fsSL https://raw.githubusercontent.com/itsredbull/lemp-auto-installer/main/install_lemp.sh | sudo bash
```

### Manual Installation

```bash
# Download the script
wget https://raw.githubusercontent.com/itsredbull/lemp-auto-installer/main/install_lemp.sh

# Make it executable
chmod +x install_lemp.sh

# Run with sudo
sudo ./install_lemp.sh
```

## 📋 Installation Process

The installer automatically performs these steps:

1. **System Detection** - Identifies your Linux distribution
2. **System Update** - Updates package repositories and system
3. **Nginx Installation** - Installs and configures web server
4. **MariaDB Setup** - Installs database server with secure configuration
5. **PHP Installation** - Installs latest PHP version with essential extensions
6. **Service Configuration** - Enables and starts all services
7. **Test Page Creation** - Creates welcome and PHP info pages
8. **Verification** - Tests all components are working

## 📊 Logging & Monitoring

All installation activities are logged to `/LEMPinstall.log`:

```bash
# View installation log
sudo cat /LEMPinstall.log

# Monitor installation progress
sudo tail -f /LEMPinstall.log
```

## 🔍 Post-Installation

### Access Your Server

After installation, access your web server:

```bash
# Your server will be available at:
http://YOUR_SERVER_IP/

# PHP info page:
http://YOUR_SERVER_IP/info.php
```

### Important Information

- **MariaDB root password** is randomly generated and saved in `/LEMPinstall.log`
- **Nginx** is configured to serve files from `/var/www/html/`
- **PHP-FPM** is configured to work with Nginx
- All services start automatically on boot

### Find Your Server IP

```bash
# Get your server's IP address
hostname -I | awk '{print $1}'

# Or use:
ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1
```

## 🔐 Security Notes

- **MariaDB root password** is automatically generated (16 characters)
- **PHP info page** (`/info.php`) should be removed in production
- Consider setting up **SSL/TLS certificates** for HTTPS
- **Firewall configuration** may be needed (ports 80, 443)

## 🛠️ Configuration Files

Key configuration files locations:

```bash
# Nginx
/etc/nginx/nginx.conf
/etc/nginx/sites-available/default

# PHP
/etc/php/*/fpm/php.ini
/etc/php/*/fpm/pool.d/www.conf

# MariaDB
/etc/mysql/mariadb.conf.d/50-server.cnf
```

## 🔧 Troubleshooting

### Common Issues

**Services not starting:**
```bash
# Check service status
sudo systemctl status nginx
sudo systemctl status mariadb
sudo systemctl status php-fpm

# Restart services
sudo systemctl restart nginx mariadb php-fpm
```

**Permission issues:**
```bash
# Fix web directory permissions
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
```

**Database connection issues:**
```bash
# Find MariaDB root password in log
sudo grep "MariaDB Root Password" /LEMPinstall.log

# Test database connection
mysql -u root -p
```

### Getting Help

- Check installation log: `/LEMPinstall.log`
- Review service logs: `journalctl -u nginx` / `journalctl -u mariadb`
- Open an [issue](https://github.com/itsredbull/lemp-auto-installer/issues) on GitHub

## 🏗️ Development & Testing

### Test Your Installation

```bash
# Test Nginx
curl -I http://localhost

# Test PHP
php -v

# Test MariaDB
sudo systemctl status mariadb
```

### Custom Configuration

After installation, you can customize:

- **Virtual hosts** in `/etc/nginx/sites-available/`
- **PHP settings** in `/etc/php/*/fpm/php.ini`
- **Database settings** in MariaDB configuration files

## 🤝 Contributing

Contributions are welcome! Areas for improvement:

- Add support for additional Linux distributions
- Implement SSL/TLS certificate automation (Let's Encrypt)
- Add WordPress/Laravel quick setup options  
- Create uninstall script
- Add backup/restore functionality
- Implement monitoring tools integration

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚡ Performance Tips

- **PHP-FPM**: Already optimized for better performance than mod_php
- **Nginx**: Configured with sensible defaults for small to medium sites
- **MariaDB**: Consider running `mysql_secure_installation` for production
- **Caching**: Consider adding Redis or Memcached for better performance

## 🔗 Related Projects

- [Docker Auto-Installer](https://github.com/itsredbull/universal-docker-installer) - Automated Docker installation

## ⭐ Show Your Support

If this installer helped you set up your LEMP stack:
- Give it a ⭐ star on GitHub
- Share it with fellow developers
- Contribute improvements
- Report issues and suggest features

---

**Built with ❤️ for web developers and system administrators**

*Need help? Open an issue or start a discussion!*
