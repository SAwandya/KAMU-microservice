-- Delivery Service Database Initialization
-- This script creates riders and delivery trips

-- Delivery riders
INSERT INTO Riders (id, user_id, name, phone, license_number, vehicle_type, vehicle_plate, is_active, current_status, latitude, longitude, created_at, updated_at)
VALUES
  ('rider_001', 'usr_005', 'Delivery Driver', '1231231234', 'DL1234567', 'MOTORCYCLE', 'AB123CD', true, 'AVAILABLE', 37.7749, -122.4194, NOW(), NOW()),
  ('rider_002', 'usr_006', 'Jane Rider', '9879879876', 'DL7654321', 'CAR', 'XY789ZW', true, 'AVAILABLE', 37.7833, -122.4167, NOW(), NOW()),
  ('rider_003', 'usr_007', 'Sam Speedy', '5675675678', 'DL9876543', 'BICYCLE', NULL, false, 'OFFLINE', 37.7694, -122.4862, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  current_status = VALUES(current_status),
  latitude = VALUES(latitude),
  longitude = VALUES(longitude),
  updated_at = NOW();

-- Delivery trips
INSERT INTO Trips (id, order_id, rider_id, status, pickup_location, delivery_location, pickup_time, delivery_time, estimated_arrival_time, distance_km, duration_minutes, created_at, updated_at)
VALUES
  -- Completed deliveries
  ('trip_001', 'ord_001', 'rider_001', 'COMPLETED', 
   '{"lat": 37.7749, "lng": -122.4194, "address": "Tasty Bites, 123 Food St, Cuisine City"}', 
   '{"lat": 37.7833, "lng": -122.4167, "address": "123 Main St, City"}',
   DATE_SUB(NOW(), INTERVAL 10 DAY), 
   DATE_SUB(NOW(), INTERVAL 10 DAY), 
   DATE_SUB(NOW(), INTERVAL 10 DAY),
   3.5, 15, 
   DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
   
  ('trip_002', 'ord_002', 'rider_002', 'COMPLETED', 
   '{"lat": 37.7694, "lng": -122.4862, "address": "Spice Garden, 456 Spice Ave, Flavor Town"}', 
   '{"lat": 37.7879, "lng": -122.4074, "address": "456 Elm St, Town"}',
   DATE_SUB(NOW(), INTERVAL 5 DAY), 
   DATE_SUB(NOW(), INTERVAL 5 DAY), 
   DATE_SUB(NOW(), INTERVAL 5 DAY),
   4.8, 22, 
   DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
   
  ('trip_003', 'ord_003', 'rider_001', 'COMPLETED', 
   '{"lat": 37.7694, "lng": -122.4074, "address": "Burger Palace, 789 Burger Blvd, Meal City"}', 
   '{"lat": 37.7833, "lng": -122.4167, "address": "123 Main St, City"}',
   DATE_SUB(NOW(), INTERVAL 2 DAY), 
   DATE_SUB(NOW(), INTERVAL 2 DAY), 
   DATE_SUB(NOW(), INTERVAL 2 DAY),
   2.9, 12, 
   DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),

  -- Ongoing delivery  
  ('trip_004', 'ord_005', 'rider_002', 'PREPARING', 
   '{"lat": 37.7749, "lng": -122.4194, "address": "Tasty Bites, 123 Food St, Cuisine City"}', 
   '{"lat": 37.7833, "lng": -122.4167, "address": "123 Main St, City"}',
   NULL, 
   NULL, 
   DATE_ADD(NOW(), INTERVAL 20 MINUTE),
   3.5, 15, 
   DATE_SUB(NOW(), INTERVAL 30 MINUTE), DATE_SUB(NOW(), INTERVAL 30 MINUTE))
ON DUPLICATE KEY UPDATE
  status = VALUES(status),
  updated_at = NOW();

-- Trip status history
INSERT INTO TripStatusHistory (id, trip_id, status, timestamp, notes, latitude, longitude, created_at, updated_at)
VALUES
  -- Trip 1 history
  ('triphist_001', 'trip_001', 'ASSIGNED', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Rider assigned to trip', 37.7749, -122.4194, DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('triphist_002', 'trip_001', 'ACCEPTED', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Rider accepted trip', 37.7749, -122.4194, DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('triphist_003', 'trip_001', 'ARRIVED_AT_RESTAURANT', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Rider arrived at restaurant', 37.7749, -122.4194, DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('triphist_004', 'trip_001', 'PICKED_UP', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Order picked up', 37.7749, -122.4194, DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('triphist_005', 'trip_001', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Order delivered', 37.7833, -122.4167, DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  
  -- Trip 2 history
  ('triphist_006', 'trip_002', 'ASSIGNED', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Rider assigned to trip', 37.7694, -122.4862, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('triphist_007', 'trip_002', 'ACCEPTED', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Rider accepted trip', 37.7694, -122.4862, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('triphist_008', 'trip_002', 'ARRIVED_AT_RESTAURANT', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Rider arrived at restaurant', 37.7694, -122.4862, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('triphist_009', 'trip_002', 'PICKED_UP', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Order picked up', 37.7694, -122.4862, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('triphist_010', 'trip_002', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Order delivered', 37.7879, -122.4074, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  
  -- Trip 3 history
  ('triphist_011', 'trip_003', 'ASSIGNED', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Rider assigned to trip', 37.7694, -122.4074, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('triphist_012', 'trip_003', 'ACCEPTED', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Rider accepted trip', 37.7694, -122.4074, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('triphist_013', 'trip_003', 'ARRIVED_AT_RESTAURANT', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Rider arrived at restaurant', 37.7694, -122.4074, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('triphist_014', 'trip_003', 'PICKED_UP', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Order picked up', 37.7694, -122.4074, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('triphist_015', 'trip_003', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Order delivered', 37.7833, -122.4167, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  
  -- Trip 4 history (in progress)
  ('triphist_016', 'trip_004', 'ASSIGNED', DATE_SUB(NOW(), INTERVAL 30 MINUTE), 'Rider assigned to trip', 37.7749, -122.4194, DATE_SUB(NOW(), INTERVAL 30 MINUTE), DATE_SUB(NOW(), INTERVAL 30 MINUTE)),
  ('triphist_017', 'trip_004', 'ACCEPTED', DATE_SUB(NOW(), INTERVAL 25 MINUTE), 'Rider accepted trip', 37.7749, -122.4194, DATE_SUB(NOW(), INTERVAL 25 MINUTE), DATE_SUB(NOW(), INTERVAL 25 MINUTE)),
  ('triphist_018', 'trip_004', 'PREPARING', DATE_SUB(NOW(), INTERVAL 20 MINUTE), 'Waiting for order preparation', 37.7749, -122.4194, DATE_SUB(NOW(), INTERVAL 20 MINUTE), DATE_SUB(NOW(), INTERVAL 20 MINUTE))
ON DUPLICATE KEY UPDATE
  updated_at = NOW();