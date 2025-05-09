-- Restaurant Service Database Initialization
-- This script populates restaurant data, food items, and schedules

-- Restaurant data
INSERT INTO Restaurants (id, name, owner_id, cuisine_type, address, phone, email, description, image_url, rating, created_at, updated_at)
VALUES 
  ('rest_001', 'Tasty Bites', 'usr_004', 'Italian', '123 Food St, Cuisine City', '9876543210', 'contact@tastybites.com', 'Authentic Italian cuisine with a modern twist', 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4', 4.7, NOW(), NOW()),
  ('rest_002', 'Spice Garden', 'usr_004', 'Indian', '456 Spice Ave, Flavor Town', '5432109876', 'hello@spicegarden.com', 'Traditional Indian dishes with rich flavors', 'https://images.unsplash.com/photo-1517244683847-7456b63c5969', 4.5, NOW(), NOW()),
  ('rest_003', 'Burger Palace', 'usr_004', 'American', '789 Burger Blvd, Meal City', '1122334455', 'orders@burgerpalace.com', 'Gourmet burgers and sides', 'https://images.unsplash.com/photo-1561758033-d89a9ad46330', 4.3, NOW(), NOW()),
  ('rest_004', 'Sushi Heaven', 'usr_004', 'Japanese', '321 Fish Ln, Ocean Town', '5566778899', 'info@sushiheaven.com', 'Fresh sushi and Japanese delicacies', 'https://images.unsplash.com/photo-1553621042-f6e147245754', 4.8, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  updated_at = NOW();

-- Restaurant schedule data
INSERT INTO RestaurantSchedules (id, restaurant_id, created_at, updated_at)
VALUES 
  ('sched_001', 'rest_001', NOW(), NOW()),
  ('sched_002', 'rest_002', NOW(), NOW()),
  ('sched_003', 'rest_003', NOW(), NOW()),
  ('sched_004', 'rest_004', NOW(), NOW())
ON DUPLICATE KEY UPDATE
  updated_at = NOW();

-- Work days data (Mon-Sun: 1-7)
INSERT INTO WorkDays (id, schedule_id, day_of_week, is_open, created_at, updated_at)
VALUES
  -- Tasty Bites (open Mon-Sat)
  ('wd_001', 'sched_001', 1, true, NOW(), NOW()),
  ('wd_002', 'sched_001', 2, true, NOW(), NOW()),
  ('wd_003', 'sched_001', 3, true, NOW(), NOW()),
  ('wd_004', 'sched_001', 4, true, NOW(), NOW()),
  ('wd_005', 'sched_001', 5, true, NOW(), NOW()),
  ('wd_006', 'sched_001', 6, true, NOW(), NOW()),
  ('wd_007', 'sched_001', 7, false, NOW(), NOW()),
  
  -- Spice Garden (open all days)
  ('wd_008', 'sched_002', 1, true, NOW(), NOW()),
  ('wd_009', 'sched_002', 2, true, NOW(), NOW()),
  ('wd_010', 'sched_002', 3, true, NOW(), NOW()),
  ('wd_011', 'sched_002', 4, true, NOW(), NOW()),
  ('wd_012', 'sched_002', 5, true, NOW(), NOW()),
  ('wd_013', 'sched_002', 6, true, NOW(), NOW()),
  ('wd_014', 'sched_002', 7, true, NOW(), NOW()),
  
  -- Burger Palace (open all days)
  ('wd_015', 'sched_003', 1, true, NOW(), NOW()),
  ('wd_016', 'sched_003', 2, true, NOW(), NOW()),
  ('wd_017', 'sched_003', 3, true, NOW(), NOW()),
  ('wd_018', 'sched_003', 4, true, NOW(), NOW()),
  ('wd_019', 'sched_003', 5, true, NOW(), NOW()),
  ('wd_020', 'sched_003', 6, true, NOW(), NOW()),
  ('wd_021', 'sched_003', 7, true, NOW(), NOW()),
  
  -- Sushi Heaven (closed Sunday and Monday)
  ('wd_022', 'sched_004', 1, false, NOW(), NOW()),
  ('wd_023', 'sched_004', 2, true, NOW(), NOW()),
  ('wd_024', 'sched_004', 3, true, NOW(), NOW()),
  ('wd_025', 'sched_004', 4, true, NOW(), NOW()),
  ('wd_026', 'sched_004', 5, true, NOW(), NOW()),
  ('wd_027', 'sched_004', 6, true, NOW(), NOW()),
  ('wd_028', 'sched_004', 7, false, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  is_open = VALUES(is_open),
  updated_at = NOW();

-- Work hours data
INSERT INTO WorkHours (id, work_day_id, open_time, close_time, created_at, updated_at)
VALUES
  -- Tasty Bites hours
  ('wh_001', 'wd_001', '09:00:00', '22:00:00', NOW(), NOW()),
  ('wh_002', 'wd_002', '09:00:00', '22:00:00', NOW(), NOW()),
  ('wh_003', 'wd_003', '09:00:00', '22:00:00', NOW(), NOW()),
  ('wh_004', 'wd_004', '09:00:00', '22:00:00', NOW(), NOW()),
  ('wh_005', 'wd_005', '09:00:00', '23:00:00', NOW(), NOW()),
  ('wh_006', 'wd_006', '10:00:00', '23:00:00', NOW(), NOW()),
  
  -- Spice Garden hours
  ('wh_007', 'wd_008', '11:00:00', '22:00:00', NOW(), NOW()),
  ('wh_008', 'wd_009', '11:00:00', '22:00:00', NOW(), NOW()),
  ('wh_009', 'wd_010', '11:00:00', '22:00:00', NOW(), NOW()),
  ('wh_010', 'wd_011', '11:00:00', '22:00:00', NOW(), NOW()),
  ('wh_011', 'wd_012', '11:00:00', '23:00:00', NOW(), NOW()),
  ('wh_012', 'wd_013', '11:00:00', '23:00:00', NOW(), NOW()),
  ('wh_013', 'wd_014', '11:00:00', '21:00:00', NOW(), NOW()),
  
  -- Burger Palace hours
  ('wh_014', 'wd_015', '10:00:00', '23:00:00', NOW(), NOW()),
  ('wh_015', 'wd_016', '10:00:00', '23:00:00', NOW(), NOW()),
  ('wh_016', 'wd_017', '10:00:00', '23:00:00', NOW(), NOW()),
  ('wh_017', 'wd_018', '10:00:00', '23:00:00', NOW(), NOW()),
  ('wh_018', 'wd_019', '10:00:00', '01:00:00', NOW(), NOW()),
  ('wh_019', 'wd_020', '10:00:00', '01:00:00', NOW(), NOW()),
  ('wh_020', 'wd_021', '10:00:00', '23:00:00', NOW(), NOW()),
  
  -- Sushi Heaven hours
  ('wh_021', 'wd_023', '12:00:00', '22:00:00', NOW(), NOW()),
  ('wh_022', 'wd_024', '12:00:00', '22:00:00', NOW(), NOW()),
  ('wh_023', 'wd_025', '12:00:00', '22:00:00', NOW(), NOW()),
  ('wh_024', 'wd_026', '12:00:00', '23:00:00', NOW(), NOW()),
  ('wh_025', 'wd_027', '12:00:00', '23:00:00', NOW(), NOW())
ON DUPLICATE KEY UPDATE
  open_time = VALUES(open_time),
  close_time = VALUES(close_time),
  updated_at = NOW();

-- Food items data
INSERT INTO FoodItems (id, restaurant_id, name, description, price, image_url, category, is_available, created_at, updated_at)
VALUES
  -- Tasty Bites menu
  ('food_001', 'rest_001', 'Margherita Pizza', 'Classic pizza with tomato, mozzarella, and basil', 10.99, 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3', 'Pizza', true, NOW(), NOW()),
  ('food_002', 'rest_001', 'Fettuccine Alfredo', 'Creamy pasta with parmesan cheese', 12.99, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'Pasta', true, NOW(), NOW()),
  ('food_003', 'rest_001', 'Tiramisu', 'Classic Italian dessert with coffee and mascarpone', 6.99, 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9', 'Dessert', true, NOW(), NOW()),
  ('food_004', 'rest_001', 'Bruschetta', 'Toasted bread with tomatoes, garlic, and basil', 7.99, 'https://images.unsplash.com/photo-1572695157366-5e585ab2b69f', 'Appetizer', true, NOW(), NOW()),
  
  -- Spice Garden menu
  ('food_005', 'rest_002', 'Butter Chicken', 'Tender chicken in a rich buttery tomato sauce', 14.99, 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db', 'Main Course', true, NOW(), NOW()),
  ('food_006', 'rest_002', 'Vegetable Biryani', 'Fragrant rice dish with mixed vegetables and spices', 11.99, 'https://images.unsplash.com/photo-1589302168068-964664d93dc0', 'Rice', true, NOW(), NOW()),
  ('food_007', 'rest_002', 'Garlic Naan', 'Freshly baked flatbread with garlic', 2.99, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f', 'Bread', true, NOW(), NOW()),
  ('food_008', 'rest_002', 'Gulab Jamun', 'Sweet milk solid balls soaked in rose syrup', 4.99, 'https://images.unsplash.com/photo-1589729132389-8f0e2033991b', 'Dessert', true, NOW(), NOW()),
  
  -- Burger Palace menu
  ('food_009', 'rest_003', 'Classic Cheeseburger', 'Beef patty with American cheese, lettuce, and tomato', 9.99, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd', 'Burger', true, NOW(), NOW()),
  ('food_010', 'rest_003', 'Loaded Fries', 'French fries topped with cheese, bacon, and green onions', 6.99, 'https://images.unsplash.com/photo-1585109649139-366815a0d713', 'Sides', true, NOW(), NOW()),
  ('food_011', 'rest_003', 'Chocolate Milkshake', 'Rich and creamy chocolate shake', 4.99, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699', 'Beverage', true, NOW(), NOW()),
  ('food_012', 'rest_003', 'Onion Rings', 'Crispy battered onion rings', 4.99, 'https://images.unsplash.com/photo-1639024471283-03518883512d', 'Sides', true, NOW(), NOW()),
  
  -- Sushi Heaven menu
  ('food_013', 'rest_004', 'California Roll', 'Crab, avocado, and cucumber roll', 8.99, 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c', 'Sushi Roll', true, NOW(), NOW()),
  ('food_014', 'rest_004', 'Salmon Nigiri', 'Fresh salmon over pressed rice', 9.99, 'https://images.unsplash.com/photo-1534482421-64566f976cfa', 'Nigiri', true, NOW(), NOW()),
  ('food_015', 'rest_004', 'Miso Soup', 'Traditional Japanese soup with tofu and seaweed', 3.99, 'https://images.unsplash.com/photo-1607301406259-dfb186e15de8', 'Soup', true, NOW(), NOW()),
  ('food_016', 'rest_004', 'Green Tea Ice Cream', 'Creamy matcha flavored ice cream', 4.99, 'https://images.unsplash.com/photo-1561845730-208ad5910553', 'Dessert', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  description = VALUES(description),
  price = VALUES(price),
  is_available = VALUES(is_available),
  updated_at = NOW();