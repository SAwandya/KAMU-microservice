const route = require("express").Router();
const restaurantController = require("../controllers/restaurantController");
const {
  authenticate,
  authorizeRole,
} = require("../middlewares/authMiddleware");

route.post(
  "/",
  authenticate,
  authorizeRole("RestaurantAdmin"),
  restaurantController.register
);
route.get(
  "/me",
  authenticate,
  authorizeRole("RestaurantAdmin"),
  restaurantController.getMine
);
// Get restaurant by ID - publicly accessible endpoint
route.get("/:id", restaurantController.getById);
route.put(
  "/:id/approve",
  authenticate,
  authorizeRole("SystemAdmin"),
  restaurantController.approve
);
route.put(
  "/:id",
  authenticate,
  authorizeRole("RestaurantAdmin"),
  restaurantController.update
);
route.delete(
  "/:id",
  authenticate,
  authorizeRole("RestaurantAdmin"),
  restaurantController.delete
);
module.exports = route;
