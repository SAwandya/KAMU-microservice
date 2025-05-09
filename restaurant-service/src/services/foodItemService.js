const repoFI = require('../repositories/foodItemRepository');

// New method to get food items by restaurant ID
exports.getByRestaurantId = (restaurantId) => repoFI.findByRestaurant(restaurantId);

exports.add = (data) => repoFI.create(data);
exports.list = (rid) => repoFI.findByRestaurant(rid);
exports.update = (id, data) => repoFI.update(id, data);
exports.delete = (id) => repoFI.delete(id);
