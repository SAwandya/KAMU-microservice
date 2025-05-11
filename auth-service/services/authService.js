const userRepository = require("../repositories/userRepository");
const { hashPassword, comparePassword } = require("../utils/passwordUtils");
const {
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
  generateRefreshTokenHash,
} = require("../utils/tokenUtils");
const { REFRESH_TOKEN } = require("../config/jwt");


exports.registerCustomer = async (userData) => {
  // Check if user already exists
  const existingUser = await userRepository.findByEmail(userData.email);
  if (existingUser) {
    throw new Error("Email already exists");
  }

  // Hash password
  const hashedPassword = await hashPassword(userData.password);

  // Create user
  const user = await userRepository.createCustomer({
    fullName: userData.fullName,
    email: userData.email,
    password: hashedPassword,
    role: userData.role,
  });

  return {
    id: user.id,
    fullName: user.fullName,
    email: user.email,
    role: user.role,
  };
};

exports.getAllUser = async () => {
  const users = await userRepository.findAllUsers();
  return users.map((user) => ({
    id: user.id,
    fullName: user.fullName,
    email: user.email,
    role: user.role
  }));
}

exports.getUserById = async (userId) => {
  const user = await userRepository.findById(userId);
  if (!user) {
    throw new Error("User not found");
  }
  return {
    id: user.id,
    fullName: user.fullName,
    email: user.email,
    role: user.role,
    vehicleREG: user.vehicleREG,
  };
};

exports.registerRider = async (userData) => {
  // Check if user already exists
  const existingUser = await userRepository.findByEmail(userData.email);
  if (existingUser) {
    throw new Error("Email already exists");
  }

  const existingVehicle = await userRepository.findByVehicleREG(
    userData.vehicleREG
  );
  if (existingVehicle) {
    throw new Error("Vehicle registration number already exists");
  }

  // Hash password
  const hashedPassword = await hashPassword(userData.password);

  // Create user
  const user = await userRepository.createRider({
    fullName: userData.fullName,
    email: userData.email,
    password: hashedPassword,
    role: userData.role,
    vehicleREG: userData.vehicleREG,
  });

  return {
    id: user.id,
    fullName: user.fullName,
    email: user.email,
    role: user.role,
    vehicleREG: user.vehicleREG,
  };
}

exports.login = async (email, password) => {
  // Find user
  const user = await userRepository.findByEmail(email);
  if (!user) {
    throw new Error("Invalid credentials");
  }

  // Verify password
  const isPasswordValid = await comparePassword(password, user.password);
  if (!isPasswordValid) {
    throw new Error("Invalid credentials");
  }

  console.log("User role:", user.role); // Debugging line

  // Generate tokens
  const accessToken = generateAccessToken(user.id, user.role);
  const refreshToken = generateRefreshToken(user.id, user.role);

  // Store refresh token hash
  const refreshTokenHash = generateRefreshTokenHash(refreshToken);
  await userRepository.saveRefreshToken(
    user.id,
    refreshTokenHash,
    refreshToken,
    REFRESH_TOKEN.expiry
  );

  return {
    user: {
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      role: user.role,
    },
    tokens: {
      accessToken,
      refreshToken,
    },
  };
};

exports.refreshToken = async (refreshToken) => {
  // Verify refresh token
  const decoded = verifyRefreshToken(refreshToken);
  if (!decoded) {
    throw new Error("Invalid refresh token");
  }

  // Find user
  const user = await userRepository.findById(decoded.userId);
  if (!user) {
    throw new Error("User not found");
  }

  // Verify token exists in database
  const refreshTokenHash = generateRefreshTokenHash(refreshToken);
  const storedToken = await userRepository.findRefreshToken(
    user.id,
    refreshTokenHash
  );
  if (!storedToken) {
    throw new Error("Invalid refresh token");
  }

  // Generate new tokens
  const newAccessToken = generateAccessToken(user.id, user.role);
  const newRefreshToken = generateRefreshToken(user.id, user.role);

  // Replace old refresh token with new one
  await userRepository.deleteRefreshToken(user.id, refreshTokenHash);
  const newRefreshTokenHash = generateRefreshTokenHash(newRefreshToken);
  await userRepository.saveRefreshToken(user.id, newRefreshTokenHash);

  return {
    accessToken: newAccessToken,
    refreshToken: newRefreshToken,
  };
};

exports.logout = async (userId, refreshToken) => {
  if (!refreshToken) return true;

  const refreshTokenHash = generateRefreshTokenHash(refreshToken);
  return await userRepository.deleteRefreshToken(userId, refreshTokenHash);
};

exports.logoutAll = async (userId) => {
  return await userRepository.deleteAllRefreshTokens(userId);
};

exports.updateUser = async (userId, userData) => {
  // Add any validation or business logic here
  // For example, prevent changing roles if not allowed, or hash password if it's being updated
  if (userData.password) {
    userData.password = await hashPassword(userData.password);
  }
  const updatedUser = await userRepository.updateUser(userId, userData);
  if (!updatedUser) {
    throw new Error("User not found or update failed");
  }
  // Return a cleaned-up user object, excluding password for example
  const { password, ...userWithoutPassword } = updatedUser;
  return userWithoutPassword;
};

exports.deleteUser = async (userId) => {
  // Add any checks here, e.g., ensure admin is not deleting themselves
  const result = await userRepository.deleteUser(userId);
  if (!result) {
    throw new Error("User not found or delete failed");
  }
  return { message: "User deleted successfully" };
};
