const poolFI = require("../config/database");
const FoodItem = require("../models/FoodItem");

exports.create = async (data) => {
  const { restaurantId, name, description, price, prepareTime, isPromotion, image } = data;

  // Store image in memory but don't try to save it to database yet
  try {
    // Insert without image column to avoid the "Unknown column" error
    const [r] = await poolFI.execute(
      `INSERT INTO FoodItem (restaurantId, name, description, price, prepareTime, isPromotion) 
       VALUES (?, ?, ?, ?, ?, ?)`,
      [restaurantId, name, description, price, prepareTime, isPromotion]
    );

    // Return object with image for front-end, even though it's not in database yet
    return new FoodItem(
      r.insertId,
      restaurantId,
      name,
      description,
      price,
      prepareTime,
      isPromotion,
      image // Include in the model, though not saved in DB yet
    );
  } catch (error) {
    console.error("Error creating food item:", error);
    throw error;
  }
};

exports.findByRestaurant = async (rid) => {
  try {
    const [rows] = await poolFI.execute(
      `SELECT id, restaurantId, name, description, price, prepareTime, isPromotion 
       FROM FoodItem WHERE restaurantId = ?`,
      [rid]
    );

    return rows.map(
      (r) =>
        new FoodItem(
          r.id,
          r.restaurantId,
          r.name,
          r.description,
          r.price,
          r.prepareTime,
          !!r.isPromotion,
          null // No image available from database yet
        )
    );
  } catch (error) {
    console.error(`Error finding food items for restaurant ${rid}:`, error);
    throw error;
  }
};

exports.update = async (id, data) => {
  const f = [],
    v = [];

  // Only update fields that exist in the database
  ["name", "description", "price", "prepareTime", "isPromotion"].forEach(
    (k) => {
      if (data[k] !== undefined) {
        f.push(`${k}=?`);
        v.push(data[k]);
      }
    }
  );

  if (!f.length) return null;
  v.push(id);

  try {
    await poolFI.execute(`UPDATE FoodItem SET ${f.join(",")} WHERE id=?`, v);

    const [r] = await poolFI.execute(
      `SELECT id, restaurantId, name, description, price, prepareTime, isPromotion 
       FROM FoodItem WHERE id=?`,
      [id]
    );

    if (!r.length) return null;

    const x = r[0];
    return new FoodItem(
      x.id,
      x.restaurantId,
      x.name,
      x.description,
      x.price,
      x.prepareTime,
      !!x.isPromotion,
      data.image // Keep the image in the returned object even if not saved
    );
  } catch (error) {
    console.error("Error updating food item:", error);
    throw error;
  }
};

exports.delete = async (id) => {
  await poolFI.execute(`DELETE FROM FoodItem WHERE id=?`, [id]);
};
