-- Promotion Service Database Initialization
-- This script creates various promotions and coupon codes

-- Create promotion types
INSERT INTO PromotionTypes (id, name, description, created_at, updated_at)
VALUES
  ('prtype_001', 'PERCENTAGE_DISCOUNT', 'Percentage discount on total order value', NOW(), NOW()),
  ('prtype_002', 'FLAT_DISCOUNT', 'Flat discount amount on total order value', NOW(), NOW()),
  ('prtype_003', 'FREE_DELIVERY', 'Free delivery on order', NOW(), NOW()),
  ('prtype_004', 'BUY_ONE_GET_ONE', 'Buy one get one free on selected items', NOW(), NOW())
ON DUPLICATE KEY UPDATE
  updated_at = NOW();

-- Create promotions
INSERT INTO Promotions (id, name, description, promotion_type_id, start_date, end_date, discount_value, min_order_value, max_discount, is_active, usage_limit, image_url, terms_conditions, created_at, updated_at)
VALUES
  ('promo_001', 'WELCOME20', '20% off on your first order', 'prtype_001', 
   DATE_SUB(NOW(), INTERVAL 30 DAY), DATE_ADD(NOW(), INTERVAL 60 DAY), 
   20.00, 15.00, 50.00, true, 1, 
   'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe',
   'Valid for new users only. Minimum order value $15. Maximum discount $50.', 
   NOW(), NOW()),
   
  ('promo_002', 'FLAT10', '$10 off on orders above $50', 'prtype_002', 
   DATE_SUB(NOW(), INTERVAL 15 DAY), DATE_ADD(NOW(), INTERVAL 15 DAY), 
   10.00, 50.00, 10.00, true, 0, 
   'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
   'Valid on all orders above $50. Cannot be combined with other offers.', 
   NOW(), NOW()),
   
  ('promo_003', 'FREEDEL', 'Free delivery on all orders', 'prtype_003', 
   DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), 
   0.00, 25.00, 5.00, true, 2, 
   'https://images.unsplash.com/photo-1526367790999-0150786686a2',
   'Valid for orders above $25. Limited to 2 uses per user.', 
   NOW(), NOW()),
   
  ('promo_004', 'BOGO_PIZZA', 'Buy one pizza, get one free', 'prtype_004', 
   DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(NOW(), INTERVAL 4 DAY), 
   100.00, 0.00, 0.00, true, 1, 
   'https://images.unsplash.com/photo-1513104890138-7c749659a591',
   'Valid only for pizzas of equal or lesser value. Only at participating restaurants.', 
   NOW(), NOW())
ON DUPLICATE KEY UPDATE
  is_active = VALUES(is_active),
  updated_at = NOW();

-- Create user coupons (assigning promotions to users)
INSERT INTO UserCoupons (id, user_id, promotion_id, coupon_code, is_used, is_active, expires_at, created_at, updated_at)
VALUES
  ('ucoup_001', 'usr_001', 'promo_001', 'WELCOME20-USER1', false, true, DATE_ADD(NOW(), INTERVAL 60 DAY), NOW(), NOW()),
  ('ucoup_002', 'usr_002', 'promo_001', 'WELCOME20-USER2', false, true, DATE_ADD(NOW(), INTERVAL 60 DAY), NOW(), NOW()),
  ('ucoup_003', 'usr_001', 'promo_002', 'FLAT10-USER1', false, true, DATE_ADD(NOW(), INTERVAL 15 DAY), NOW(), NOW()),
  ('ucoup_004', 'usr_002', 'promo_002', 'FLAT10-USER2', false, true, DATE_ADD(NOW(), INTERVAL 15 DAY), NOW(), NOW()),
  ('ucoup_005', 'usr_001', 'promo_003', 'FREEDEL-USER1', false, true, DATE_ADD(NOW(), INTERVAL 2 DAY), NOW(), NOW()),
  ('ucoup_006', 'usr_001', 'promo_004', 'BOGO-PIZZA-USER1', false, true, DATE_ADD(NOW(), INTERVAL 4 DAY), NOW(), NOW())
ON DUPLICATE KEY UPDATE
  is_active = VALUES(is_active),
  updated_at = NOW();

-- Create restaurant-specific promotions
INSERT INTO RestaurantPromotions (id, restaurant_id, promotion_id, is_active, created_at, updated_at)
VALUES
  ('rpromo_001', 'rest_001', 'promo_004', true, NOW(), NOW()),
  ('rpromo_002', 'rest_002', 'promo_002', true, NOW(), NOW()),
  ('rpromo_003', 'rest_003', 'promo_003', true, NOW(), NOW()),
  ('rpromo_004', 'rest_004', 'promo_002', true, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  is_active = VALUES(is_active),
  updated_at = NOW();

-- Create promotion redemption history
INSERT INTO PromotionRedemptions (id, user_id, promotion_id, order_id, discount_amount, created_at, updated_at)
VALUES
  ('redemp_001', 'usr_002', 'promo_001', 'ord_002', 4.30, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('redemp_002', 'usr_001', 'promo_003', 'ord_003', 2.99, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY))
ON DUPLICATE KEY UPDATE
  updated_at = NOW();