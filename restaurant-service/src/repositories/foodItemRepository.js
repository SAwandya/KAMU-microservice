const poolFI = require("../config/database");
const FoodItem = require("../models/FoodItem");
exports.create = async (data) => {
  const { restaurantId, name, description, price, prepareTime, isPromotion } =
    data;
  const [r] = await poolFI.execute(
    `INSERT INTO FoodItem (restaurantId,name,description,price,prepareTime,isPromotion) VALUES (?,?,?,?,?,?)`,
    [restaurantId, name, description, price, prepareTime, isPromotion]
  );
  return new FoodItem(
    r.insertId,
    restaurantId,
    name,
    description,
    price,
    prepareTime,
    isPromotion
  );
};
exports.findByRestaurant = async (rid) => {
  const [rows] = await poolFI.execute(
    `SELECT * FROM FoodItem WHERE restaurantId=?`,
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
        !!r.isPromotion
      )
  );
};
exports.update = async (id, data) => {
  const f = [],
    v = [];
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
  await poolFI.execute(`UPDATE FoodItem SET ${f.join(",")} WHERE id=?`, v);
  const [r] = await poolFI.execute(`SELECT * FROM FoodItem WHERE id=?`, [id]);
  const x = r[0];
  return new FoodItem(
    x.id,
    x.restaurantId,
    x.name,
    x.description,
    x.price,
    x.prepareTime,
    !!x.isPromotion
  );
};
exports.delete = async (id) => {
  await poolFI.execute(`DELETE FROM FoodItem WHERE id=?`, [id]);
};
