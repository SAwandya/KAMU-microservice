-- Payment Service Database Initialization
-- This script creates and populates payment methods and demo payment records

-- Initial saved payment methods
INSERT INTO PaymentMethods (id, user_id, type, provider, account_number, expiry_month, expiry_year, is_default, created_at, updated_at)
VALUES
  ('pm_001', 'usr_001', 'CREDIT_CARD', 'VISA', '4111111111111111', 12, 2025, true, NOW(), NOW()),
  ('pm_002', 'usr_001', 'CREDIT_CARD', 'MASTERCARD', '5555555555554444', 10, 2026, false, NOW(), NOW()),
  ('pm_003', 'usr_002', 'CREDIT_CARD', 'VISA', '4111222233334444', 8, 2025, true, NOW(), NOW()),
  ('pm_004', 'usr_002', 'DEBIT_CARD', 'VISA', '4222333344445555', 3, 2024, false, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  updated_at = NOW();

-- Demo payment transactions
INSERT INTO Payments (id, order_id, user_id, amount, currency, status, payment_method_id, transaction_reference, payment_provider, created_at, updated_at)
VALUES
  ('pay_001', 'ord_demo1', 'usr_001', 25.99, 'USD', 'COMPLETED', 'pm_001', 'txn_demo12345', 'STRIPE', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('pay_002', 'ord_demo2', 'usr_002', 18.50, 'USD', 'COMPLETED', 'pm_003', 'txn_demo54321', 'STRIPE', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('pay_003', 'ord_demo3', 'usr_001', 36.75, 'USD', 'COMPLETED', 'pm_002', 'txn_demo67890', 'STRIPE', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('pay_004', 'ord_demo4', 'usr_002', 12.25, 'USD', 'FAILED', 'pm_004', 'txn_demo09876', 'STRIPE', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY))
ON DUPLICATE KEY UPDATE
  status = VALUES(status),
  updated_at = NOW();

-- Payment logs for tracking
INSERT INTO PaymentLogs (id, payment_id, status, message, timestamp, created_at, updated_at)
VALUES
  ('plog_001', 'pay_001', 'INITIATED', 'Payment attempt initiated', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('plog_002', 'pay_001', 'PROCESSING', 'Payment processing with provider', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  ('plog_003', 'pay_001', 'COMPLETED', 'Payment successfully processed', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
  
  ('plog_004', 'pay_002', 'INITIATED', 'Payment attempt initiated', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('plog_005', 'pay_002', 'PROCESSING', 'Payment processing with provider', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('plog_006', 'pay_002', 'COMPLETED', 'Payment successfully processed', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
  
  ('plog_007', 'pay_003', 'INITIATED', 'Payment attempt initiated', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('plog_008', 'pay_003', 'PROCESSING', 'Payment processing with provider', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  ('plog_009', 'pay_003', 'COMPLETED', 'Payment successfully processed', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
  
  ('plog_010', 'pay_004', 'INITIATED', 'Payment attempt initiated', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
  ('plog_011', 'pay_004', 'PROCESSING', 'Payment processing with provider', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
  ('plog_012', 'pay_004', 'FAILED', 'Payment failed: insufficient funds', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY))
ON DUPLICATE KEY UPDATE
  updated_at = NOW();