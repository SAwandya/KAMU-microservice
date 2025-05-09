const fi = require("express").Router();
const cFI = require("../controllers/foodItemController");
const {
  authenticate,
  authorizeRole,
} = require("../middlewares/authMiddleware");

// Public endpoint to get menu items by restaurant ID
fi.get("/restaurant/:restaurantId", cFI.getByRestaurantId);

// Public endpoint for creating a food item (for testing)
fi.post("/public", cFI.createPublic);

fi.post("/", authenticate, authorizeRole("RestaurantAdmin"), cFI.add);
fi.get("/", authenticate, authorizeRole("RestaurantAdmin"), cFI.list);
fi.put("/:id", authenticate, authorizeRole("RestaurantAdmin"), cFI.update);
fi.delete("/:id", authenticate, authorizeRole("RestaurantAdmin"), cFI.delete);
module.exports = fi;
