#!/bin/bash

# Install dependencies
echo "Installing dependencies..."
apt update && apt install -y unzip curl php-cli php-mbstring git sqlite3

# Clone Pterodactyl Panel
echo "Cloning Pterodactyl Panel..."
git clone https://github.com/pterodactyl/panel.git
cd panel

# Install PHP dependencies
echo "Installing PHP dependencies..."
curl -sS https://getcomposer.org/installer | php
php composer.phar install --no-dev --optimize-autoloader

# Set up environment
echo "Setting up environment..."
cp .env.example .env
php artisan key:generate

# Use SQLite for database (No MySQL required)
echo "Configuring SQLite database..."
echo "DB_CONNECTION=sqlite" >> .env
touch database/database.sqlite

# Run migrations
echo "Migrating database..."
php artisan migrate --seed --force

# Create Admin User
echo "Creating admin user..."
php artisan p:user:make --admin --email="admin@example.com" --password="SecurePass123"

# Start the server
echo "Starting Pterodactyl Panel..."
php artisan serve --host=0.0.0.0 --port=8080