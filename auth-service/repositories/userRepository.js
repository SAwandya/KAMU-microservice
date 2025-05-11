const db = require("../config/database");
const User = require("../models/user");
const { convertDate } = require("../utils/dateUtils"); // Corrected typo: dataUtils -> dateUtils

exports.findByEmail = async (email) => {
  try {
    const [rows] = await db.execute("SELECT * FROM users WHERE email = ?", [
      email,
    ]);

    if (rows.length === 0) return null;

    const user = rows[0];
    return new User(user.id, user.fullName, user.email, user.password, user.role);
  } catch (error) {
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.findAllUsers = async () => {
  try {
    const [rows] = await db.execute("SELECT * FROM users");

    if (rows.length === 0) return [];

    return rows.map(
      (user) =>
        new User(user.id, user.fullName, user.email, user.password, user.role)
    );
  } catch (error) {
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.findByVehicleREG = async (vehicleREG) => {
  try {
    const [rows] = await db.execute(
      "SELECT * FROM users WHERE vehicleREG = ?",
      [vehicleREG]
    );

    if (rows.length === 0) return null;

    const user = rows[0];
    return new User(user.id, user.fullName, user.email, user.password);
  } catch (error) {
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.findById = async (id) => {
  try {
    const [rows] = await db.execute("SELECT * FROM users WHERE id = ?", [id]);

    if (rows.length === 0) return null;

    const user = rows[0];
    return new User(user.id, user.fullName, user.email, user.password);
  } catch (error) {
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.createCustomer = async (user) => {
  try {
    const [result] = await db.execute(
      "INSERT INTO users (fullName, email, password, role) VALUES (?, ?, ?, ?)",
      [user.fullName, user.email, user.password, user.role]
    );

    return { ...user, id: result.insertId };
  } catch (error) {
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.createRider = async (user) => {
  try {
    const [result] = await db.execute(
      "INSERT INTO users (fullName, email, password, role, vehicleREG) VALUES (?, ?, ?, ?, ?)",
      [user.fullName, user.email, user.password, user.role, user.vehicleREG]
    );

    return { ...user, id: result.insertId };
  } catch (error) {
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.saveRefreshToken = async (userId, tokenHash, token, expire) => {
  const convertedexpire = convertDate(expire); // Pass the 'expire' variable

  try {
    // FIX 2: Corrected the order of values to match INSERT columns
    await db.execute(
      "INSERT INTO refresh_tokens (userId, token, token_hash, expires_at) VALUES (?, ?, ?, ?)",
      [userId, token, tokenHash, convertedexpire] // Swapped token and tokenHash
    );
    return true;
  } catch (error) {
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.findRefreshToken = async (userId, tokenHash) => {
  try {
    // FIX 1: Changed user_id to userId
    const [rows] = await db.execute(
      "SELECT * FROM refresh_tokens WHERE userId = ? AND token_hash = ?", // Corrected column name
      [userId, tokenHash]
    );
    return rows.length > 0 ? rows[0] : null;
  } catch (error) {
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.deleteRefreshToken = async (userId, tokenHash) => {
  try {
    // FIX 1: Changed user_id to userId
    await db.execute(
      "DELETE FROM refresh_tokens WHERE userId = ? AND token_hash = ?", // Corrected column name
      [userId, tokenHash]
    );
    return true;
  } catch (error) {
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.deleteAllRefreshTokens = async (userId) => {
  try {
    // FIX 1: Changed user_id to userId
    await db.execute("DELETE FROM refresh_tokens WHERE userId = ?", [userId]); // Corrected column name
    return true;
  } catch (error) {
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.updateUser = async (userId, userData) => {
  try {
    const fields = [];
    const values = [];
    // Dynamically build the query based on provided userData
    // Ensure only allowed fields can be updated
    const allowedFields = ['fullName', 'email', 'password', 'role', 'vehicleREG', 'active']; // Added 'active'

    Object.keys(userData).forEach(key => {
      if (allowedFields.includes(key) && userData[key] !== undefined) {
        fields.push(`${key} = ?`);
        values.push(userData[key]);
      }
    });

    if (fields.length === 0) {
      throw new Error("No valid fields provided for update");
    }

    values.push(userId); // For the WHERE clause

    const sql = `UPDATE users SET ${fields.join(', ')} WHERE id = ?`;
    const [result] = await db.execute(sql, values);

    if (result.affectedRows === 0) {
      return null; // Or throw an error if user not found
    }
    // Fetch and return the updated user data, excluding password
    const updatedUser = await this.findById(userId);
    if (updatedUser) {
      delete updatedUser.password; // Ensure password is not returned
    }
    return updatedUser;
  } catch (error) {
    console.error('Error in updateUser repository:', error);
    throw new Error(`Database error: ${error.message}`);
  }
};

exports.deleteUser = async (userId) => {
  try {
    // Optional: First, delete associated refresh tokens or handle foreign key constraints
    await db.execute("DELETE FROM refresh_tokens WHERE userId = ?", [userId]);
    const [result] = await db.execute("DELETE FROM users WHERE id = ?", [userId]);
    return result.affectedRows > 0;
  } catch (error) {
    console.error('Error in deleteUser repository:', error);
    throw new Error(`Database error: ${error.message}`);
  }
};
