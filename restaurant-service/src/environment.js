require('dotenv').config();

module.exports = {
  NODE_ENV: process.env.NODE_ENV || "development",
  PORT: process.env.PORT || 3001,

  DB_HOST: process.env.DB_HOST || "localhost",
  DB_USER: process.env.DB_USER || "root",
  DB_PASSWORD: process.env.DB_PASSWORD || "password",
  DB_NAME: process.env.DB_NAME || "order_db",
  DB_PORT: process.env.DB_PORT,

  JWT_SECRET:
    process.env.JWT_SECRET || "C4XPaAF1FvrVUVsBPIuh+gyCDIg7tv/YwfR9VPZHeEA=",

  LOG_LEVEL: process.env.LOG_LEVEL || "info",
  NATS_URL: process.env.NATS_URL || "nats://nats:4222",
};