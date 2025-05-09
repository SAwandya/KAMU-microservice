class FoodItem {
  constructor(
    id,
    restaurantId,
    name,
    description,
    price,
    prepareTime,
    isPromotion,
    image
  ) {
    this.id = id;
    this.restaurantId = restaurantId;
    this.name = name;
    this.description = description;
    this.price = price;
    this.prepareTime = prepareTime;
    this.isPromotion = isPromotion;
    this.image = image;
  }
}
module.exports = FoodItem;
