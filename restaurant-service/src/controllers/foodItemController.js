const svcFI = require("../services/foodItemService");

exports.add = async (req, res, next) => {
  try {
    const item = await svcFI.add({ ...req.body });
    res.status(201).json({ foodItem: item });
  } catch (e) {
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

exports.getByRestaurantId = async (req, res, next) => {
  try {
    const arr = await svcFI.getByRestaurantId(req.params.id);
    res.json({ foodItems: arr });
  } catch (e) {
    next(e);
  }
}

exports.update = async (req, res, next) => {
  try {
    const item = await svcFI.update(req.params.id, req.body);
    res.json({ foodItem: item });
  } catch (e) {
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
