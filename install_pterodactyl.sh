#!/bin/bash

# Pterodactyl Panel Auto Installer (No Root)
# Works on Railway, Replit, and other cloud services

echo "Starting Pterodactyl Installation..."

# Update & Install Dependencies
apt update && apt install -y unzip curl php-cli php-mbstring git

# Clone Pterodactyl Panel
git clone https://github.com/pterodactyl/panel.git
cd panel

# Install PHP Dependencies
curl -sS https://getcomposer.org/installer | php
php composer.phar install --no-dev --optimize-autoloader

# Set Up Environment
cp .env.example .env
php artisan key:generate

# Configure Database (Using SQLite for No-Root Setup)
echo "DB_CONNECTION=sqlite" >> .env
touch database/database.sqlite

# Run Database Migrations
php artisan migrate --seed --force

# Create Admin User (Replace with your details)
php artisan p:user:make --admin --email="admin@example.com" --password="SecurePass123"

echo "Pterodactyl Installed Successfully!"