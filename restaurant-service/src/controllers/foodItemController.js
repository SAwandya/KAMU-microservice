const svcFI = require("../services/foodItemService");
const restaurantSvc = require("../services/restaurantService"); // Add restaurant service import

// Public method for creating food items without authentication
exports.createPublic = async (req, res, next) => {
  try {
    console.log("Received food item data:", req.body);

    // Validate required fields
    const { name, description, price, restaurantId } = req.body;

    if (!name || !description || !price || !restaurantId) {
      return res.status(400).json({
        message: "Missing required fields",
        required: ["name", "description", "price", "restaurantId"],
        received: req.body
      });
    }

    // Check if restaurant exists before creating food item
    const restaurant = await restaurantSvc.getById(restaurantId);
    if (!restaurant) {
      return res.status(404).json({
        error: {
          message: `Restaurant with ID ${restaurantId} not found. Cannot create food item for non-existent restaurant.`,
          status: 404
        }
      });
    }

    const item = await svcFI.add(req.body);
    res.status(201).json({ foodItem: item });
  } catch (e) {
    console.error("Error creating food item:", e);
    next(e);
  }
};

// New controller method to get menu items by restaurant ID
exports.getByRestaurantId = async (req, res, next) => {
  try {
    const restaurantId = req.params.restaurantId;
    const menuItems = await svcFI.getByRestaurantId(restaurantId);
    res.json({ foodItems: menuItems });
  } catch (e) {
    console.error(`Error getting food items for restaurant ${req.params.restaurantId}:`, e);
    next(e);
  }
};

exports.add = async (req, res, next) => {
  try {
    // For authenticated restaurant owners, the restaurantId comes from their user ID
    const restaurantId = req.user.id;

    // Check if restaurant exists
    const restaurant = await restaurantSvc.getById(restaurantId);
    if (!restaurant) {
      return res.status(404).json({
        error: {
          message: `Restaurant with ID ${restaurantId} not found. Restaurant must be registered before adding menu items.`,
          status: 404
        }
      });
    }

    const item = await svcFI.add({ ...req.body, restaurantId });
    res.status(201).json({ foodItem: item });
  } catch (e) {
    console.error("Error adding food item:", e);
    next(e);
  }
};

exports.list = async (req, res, next) => {
  try {
    const arr = await svcFI.list(req.user.id);
    res.json({ foodItems: arr });
  } catch (e) {
    next(e);
  }
};

exports.update = async (req, res, next) => {
  try {
    // If the update includes a restaurantId, we need to verify it exists
    if (req.body.restaurantId) {
      const restaurant = await restaurantSvc.getById(req.body.restaurantId);
      if (!restaurant) {
        return res.status(404).json({
          error: {
            message: `Restaurant with ID ${req.body.restaurantId} not found. Cannot update food item with non-existent restaurant.`,
            status: 404
          }
        });
      }
    }

    const item = await svcFI.update(req.params.id, req.body);
    if (!item) {
      return res.status(404).json({
        error: {
          message: `Food item with ID ${req.params.id} not found.`,
          status: 404
        }
      });
    }

    res.json({ foodItem: item });
  } catch (e) {
    console.error(`Error updating food item with ID ${req.params.id}:`, e);
    next(e);
  }
};

exports.delete = async (req, res, next) => {
  try {
    await svcFI.delete(req.params.id);
    res.status(204).end();
  } catch (e) {
    next(e);
  }
};
