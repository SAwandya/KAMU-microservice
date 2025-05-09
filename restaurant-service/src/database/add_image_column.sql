-- Add image column to FoodItem table if it doesn't exist
ALTER TABLE FoodItem ADD COLUMN IF NOT EXISTS image VARCHAR(255);