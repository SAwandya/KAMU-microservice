-- Order Service Database Initialization
-- This script creates sample orders and order items

-- Sample Orders
INSERT INTO Orders (id, customer_id, restaurant_id, status, total_amount, delivery_fee, delivery_address, created_at, updated_at)
VALUES
  ('ord_001', 'usr_001', 'rest_001', 'DELIVERED', 29.97, 2.99, '123 Main St, City', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('ord_002', 'usr_002', 'rest_002', 'DELIVERED', 21.49, 2.99, '456 Elm St, Town', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('ord_003', 'usr_001', 'rest_003', 'DELIVERED', 39.74, 2.99, '123 Main St, City', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('ord_004', 'usr_002', 'rest_004', 'CANCELLED', 15.24, 2.99, '456 Elm St, Town', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
  ('ord_005', 'usr_001', 'rest_001', 'COOKING', 23.97, 2.99, '123 Main St, City', DATE_SUB(NOW(), INTERVAL 2 HOUR), DATE_SUB(NOW(), INTERVAL 2 HOUR))
ON DUPLICATE KEY UPDATE
  updated_at = NOW();

-- Order Items - for past orders
INSERT INTO OrderItems (id, order_id, food_item_id, quantity, price, name, created_at, updated_at)
VALUES
  -- Order 1 items
  ('item_001', 'ord_001', 'food_001', 2, 10.99, 'Margherita Pizza', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('item_002', 'ord_001', 'food_003', 1, 6.99, 'Tiramisu', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  
  -- Order 2 items
  ('item_003', 'ord_002', 'food_005', 1, 14.99, 'Butter Chicken', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('item_004', 'ord_002', 'food_007', 2, 2.99, 'Garlic Naan', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  
  -- Order 3 items
  ('item_005', 'ord_003', 'food_009', 3, 9.99, 'Classic Cheeseburger', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('item_006', 'ord_003', 'food_010', 1, 6.99, 'Loaded Fries', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('item_007', 'ord_003', 'food_011', 2, 4.99, 'Chocolate Milkshake', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  
  -- Order 4 items
  ('item_008', 'ord_004', 'food_013', 1, 8.99, 'California Roll', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
  ('item_009', 'ord_004', 'food_015', 1, 3.99, 'Miso Soup', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
  
  -- Order 5 items (in progress)
  ('item_010', 'ord_005', 'food_002', 1, 12.99, 'Fettuccine Alfredo', DATE_SUB(NOW(), INTERVAL 2 HOUR), DATE_SUB(NOW(), INTERVAL 2 HOUR)),
  ('item_011', 'ord_005', 'food_004', 1, 7.99, 'Bruschetta', DATE_SUB(NOW(), INTERVAL 2 HOUR), DATE_SUB(NOW(), INTERVAL 2 HOUR))
ON DUPLICATE KEY UPDATE
  updated_at = NOW();

-- Order Status History
INSERT INTO OrderStatusHistory (id, order_id, status, timestamp, notes, created_at, updated_at)
VALUES
  -- Order 1 history
  ('hist_001', 'ord_001', 'PENDING', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Order received', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('hist_002', 'ord_001', 'CONFIRMED', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Order confirmed by restaurant', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('hist_003', 'ord_001', 'COOKING', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Order being prepared', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('hist_004', 'ord_001', 'READY_FOR_PICKUP', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Order ready for delivery', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('hist_005', 'ord_001', 'OUT_FOR_DELIVERY', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Order out for delivery', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('hist_006', 'ord_001', 'DELIVERED', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Order delivered successfully', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  
  -- Order 2 history
  ('hist_007', 'ord_002', 'PENDING', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Order received', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('hist_008', 'ord_002', 'CONFIRMED', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Order confirmed by restaurant', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('hist_009', 'ord_002', 'COOKING', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Order being prepared', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('hist_010', 'ord_002', 'READY_FOR_PICKUP', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Order ready for delivery', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('hist_011', 'ord_002', 'OUT_FOR_DELIVERY', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Order out for delivery', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('hist_012', 'ord_002', 'DELIVERED', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Order delivered successfully', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  
  -- Order 3 history
  ('hist_013', 'ord_003', 'PENDING', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Order received', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('hist_014', 'ord_003', 'CONFIRMED', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Order confirmed by restaurant', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('hist_015', 'ord_003', 'COOKING', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Order being prepared', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('hist_016', 'ord_003', 'READY_FOR_PICKUP', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Order ready for delivery', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('hist_017', 'ord_003', 'OUT_FOR_DELIVERY', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Order out for delivery', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('hist_018', 'ord_003', 'DELIVERED', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Order delivered successfully', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  
  -- Order 4 history (cancelled)
  ('hist_019', 'ord_004', 'PENDING', DATE_SUB(NOW(), INTERVAL 1 DAY), 'Order received', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
  ('hist_020', 'ord_004', 'CONFIRMED', DATE_SUB(NOW(), INTERVAL 1 DAY), 'Order confirmed by restaurant', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
  ('hist_021', 'ord_004', 'CANCELLED', DATE_SUB(NOW(), INTERVAL 1 DAY), 'Order cancelled by customer', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
  
  -- Order 5 history (in progress)
  ('hist_022', 'ord_005', 'PENDING', DATE_SUB(NOW(), INTERVAL 2 HOUR), 'Order received', DATE_SUB(NOW(), INTERVAL 2 HOUR), DATE_SUB(NOW(), INTERVAL 2 HOUR)),
  ('hist_023', 'ord_005', 'CONFIRMED', DATE_SUB(NOW(), INTERVAL 1 HOUR), 'Order confirmed by restaurant', DATE_SUB(NOW(), INTERVAL 1 HOUR), DATE_SUB(NOW(), INTERVAL 1 HOUR)),
  ('hist_024', 'ord_005', 'COOKING', DATE_SUB(NOW(), INTERVAL 30 MINUTE), 'Order being prepared', DATE_SUB(NOW(), INTERVAL 30 MINUTE), DATE_SUB(NOW(), INTERVAL 30 MINUTE))
ON DUPLICATE KEY UPDATE
  updated_at = NOW();