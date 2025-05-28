#!/bin/bash


# Universal LEMP Stack Installer with Latest PHP & Components
# Compatible with: Ubuntu, Debian, CentOS, RHEL, Fedora, AlmaLinux, Rocky, Arch, Manjaro, openSUSE

LOG_FILE="/LEMPinstall.log"

init_log() {
    echo "LEMP Stack Installation Log - $(date)" > $LOG_FILE
    echo "=======================================" >> $LOG_FILE
    echo "" >> $LOG_FILE
}

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a $LOG_FILE
}

handle_error() {
    log "ERROR: $1"
    exit 1
}

detect_os() {
    log "Detecting operating system..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VERSION=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        OS="debian"
        VERSION=$(cat /etc/debian_version)
    else
        handle_error "Unable to detect OS"
    fi
    log "Detected OS: $OS $VERSION"
}

update_system() {
    log "Updating system packages..."
    case $OS in
        ubuntu|debian|linuxmint)
            apt-get update -y && apt-get upgrade -y
            apt-get install -y curl wget gnupg2 ca-certificates lsb-release apt-transport-https software-properties-common
            ;;
        centos|rhel|rocky|almalinux)
            yum update -y || dnf update -y
            yum install -y epel-release || true
            yum install -y curl wget ca-certificates yum-utils
            ;;
        fedora)
            dnf update -y
            dnf install -y curl wget ca-certificates
            ;;
        opensuse*|suse|sles)
            zypper refresh && zypper update -y
            zypper install -y curl wget ca-certificates
            ;;
        arch|manjaro)
            pacman -Syu --noconfirm
            pacman -S --noconfirm curl wget ca-certificates
            ;;
        *)
            handle_error "Unsupported OS: $OS"
            ;;
    esac
}

install_nginx() {
    log "Installing Nginx..."
    case $OS in
        ubuntu|debian|linuxmint)
            apt-get install -y nginx || handle_error "Failed to install Nginx"
            ;;
        centos|rhel|rocky|almalinux|fedora)
            yum install -y nginx || dnf install -y nginx || handle_error "Failed to install Nginx"
            ;;
        opensuse*|suse|sles)
            zypper install -y nginx || handle_error "Failed to install Nginx"
            ;;
        arch|manjaro)
            pacman -S --noconfirm nginx || handle_error "Failed to install Nginx"
            ;;
        *)
            handle_error "Unsupported OS for Nginx installation: $OS"
            ;;
    esac
    systemctl enable nginx && systemctl start nginx
}

install_database() {
    log "Installing MariaDB..."
    DB_ROOT_PASS=$(tr -dc 'A-Za-z0-9_!@#$%^&*()-+=' < /dev/urandom | head -c 16)

    case $OS in
        ubuntu|debian|linuxmint)
            curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
            apt-get update -y
            DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server || handle_error "Failed to install MariaDB"
            ;;
        centos|rhel|rocky|almalinux)
            curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
            yum install -y mariadb-server || dnf install -y mariadb-server || handle_error "Failed to install MariaDB"
            ;;
        fedora)
            dnf install -y mariadb-server || handle_error "Failed to install MariaDB"
            ;;
        opensuse*|suse|sles)
            zypper install -y mariadb mariadb-client || handle_error "Failed to install MariaDB"
            ;;
        arch|manjaro)
            pacman -S --noconfirm mariadb mariadb-clients || handle_error "Failed to install MariaDB"
            mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
            ;;
        *)
            handle_error "Unsupported OS for MariaDB installation: $OS"
            ;;
    esac

    systemctl enable mariadb || systemctl enable mysql
    systemctl start mariadb || systemctl start mysql

    mysqladmin -u root password "$DB_ROOT_PASS" || log "Could not set root password, may already be set"

    echo "MariaDB Root Password: $DB_ROOT_PASS" >> $LOG_FILE
    log "MariaDB installed and secured"
}

install_php() {
    log "Installing latest PHP and extensions..."
    case $OS in
        ubuntu|debian|linuxmint)
            add-apt-repository -y ppa:ondrej/php
            apt-get update -y
            PHP_VER=$(apt-cache search ^php[0-9]+\. | grep -oP '^php\K[0-9]+' | sort -V | tail -1)
            apt-get install -y php${PHP_VER}-fpm php${PHP_VER}-cli php${PHP_VER}-common php${PHP_VER}-mysql php${PHP_VER}-gd php${PHP_VER}-mbstring php${PHP_VER}-xml php${PHP_VER}-curl php${PHP_VER}-zip php${PHP_VER}-bcmath php${PHP_VER}-intl
            ;;
        centos|rhel|rocky|almalinux)
            yum install -y epel-release yum-utils
            yum install -y http://rpms.remirepo.net/enterprise/remi-release-$(rpm -E %{rhel}).rpm
            yum-config-manager --enable remi
            dnf module reset php -y || yum module reset php -y
            dnf module enable php:remi-8.3 -y || yum module enable php:remi-8.3 -y
            dnf install -y php php-fpm php-cli php-common php-mysqlnd php-gd php-mbstring php-xml php-curl php-zip php-bcmath php-intl || yum install -y ...
            ;;
        fedora)
            dnf install -y php php-fpm php-cli php-common php-mysqlnd php-gd php-mbstring php-xml php-curl php-zip php-bcmath php-intl
            ;;
        opensuse*|suse|sles)
            zypper install -y php8 php8-fpm php8-mysql php8-cli php8-common php8-gd php8-mbstring php8-xml php8-curl php8-zip php8-bcmath php8-intl
            ;;
        arch|manjaro)
            pacman -S --noconfirm php php-fpm php-gd php-intl php-mysql php-sqlite
            ;;
        *)
            handle_error "Unsupported OS for PHP installation: $OS"
            ;;
    esac
    systemctl enable php-fpm && systemctl start php-fpm
    log "PHP installed"
}

create_test_page() {
    mkdir -p /var/www/html
    echo "<?php phpinfo(); ?>" > /var/www/html/info.php
    echo "<h1>LEMP Stack is Running</h1>" > /var/www/html/index.html
    chown -R www-data:www-data /var/www/html || chown -R nginx:nginx /var/www/html || true
    chmod -R 755 /var/www/html
}

main() {
    init_log
    detect_os
    update_system
    install_nginx
    install_database
    install_php
    create_test_page
    log "LEMP installation complete!"
    echo "Access your server at http://$(hostname -I | awk '{print $1}')"
}

main
