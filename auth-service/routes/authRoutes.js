const express = require("express");
const router = express.Router();
const authController = require("../controllers/authController");
const { authenticate } = require("../middlewares/authMiddleware");

// Public routes
router.post("/register/customer", authController.registerCustomer);
router.post("/register/rider", authController.registerRider);
router.post("/login", authController.login);
router.post("/refresh-token", authController.refreshToken);
router.post("/validate", authController.validateToken);
router.get("/user", authController.getUser);
router.get("/user/:id", authenticate, authController.getUserById);

// Protected routes
router.post("/logout", authenticate, authController.logout);
router.post("/logout-all", authenticate, authController.logoutAll);

module.exports = router;
