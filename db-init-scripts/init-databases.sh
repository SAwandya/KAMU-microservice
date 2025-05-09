#!/bin/bash
# Database initialization script
# This script runs all SQL initialization scripts in order to populate the databases

echo "Starting database initialization..."

# Wait for databases to be ready before executing scripts
echo "Waiting for databases to be ready..."
sleep 10

# Auth Service Database
echo "Initializing Auth Service database..."
mysql -h auth-db -u root -p${DB_PASSWORD} auth_service < /docker-entrypoint-initdb.d/01-auth-init.sql

# Restaurant Service Database
echo "Initializing Restaurant Service database..."
mysql -h restaurant-db -u root -p${DB_PASSWORD} restaurant_service < /docker-entrypoint-initdb.d/02-restaurant-init.sql

# Payment Service Database
echo "Initializing Payment Service database..."
mysql -h payment-db -u root -p${DB_PASSWORD} payment_service < /docker-entrypoint-initdb.d/03-payment-init.sql

# Order Service Database
echo "Initializing Order Service database..."
mysql -h order-db -u root -p${DB_PASSWORD} order_service < /docker-entrypoint-initdb.d/04-order-init.sql

# Delivery Service Database
echo "Initializing Delivery Service database..."
mysql -h delivery-db -u root -p${DB_PASSWORD} delivery_service < /docker-entrypoint-initdb.d/05-delivery-init.sql

# Promotion Service Database
echo "Initializing Promotion Service database..."
mysql -h promotion-db -u root -p${DB_PASSWORD} promotion_service < /docker-entrypoint-initdb.d/06-promotion-init.sql

echo "Database initialization completed!"