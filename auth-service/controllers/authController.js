const authService = require("../services/authService");
const { verifyAccessToken } = require("../utils/tokenUtils");

exports.registerCustomer = async (req, res, next) => {
  try {
    const { fullName, email, password, role } = req.body;

    if (!fullName || !email || !password) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const user = await authService.registerCustomer({
      fullName,
      email,
      password,
      role,
    });
    res.status(201).json({ user });
  } catch (error) {
    next(error);
  }
};

exports.getUserById = async (req, res) => {
  const userId = req.params.id;
  if (!userId) {
    return res.status(400).json({ message: "User ID is required" });
  }
  try {
    const user = await authService.getUserById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.status(200).json(user);
  } catch (error) {
    console.error("Error fetching user:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

exports.getUser = async (req, res) => {
  try {
    const user = await authService.getAllUser();
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

exports.registerRider = async (req, res, next) => {
  try {
    const { fullName, email, password, role, vehicleREG } = req.body;

    if (!fullName || !email || !password || !vehicleREG) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const user = await authService.registerRider({
      fullName,
      email,
      password,
      role,
      vehicleREG,
    });
    res.status(201).json({ user });
  } catch (error) {
    next(error);
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res
        .status(400)
        .json({ message: "Email and password are required" });
    }

    const result = await authService.login(email, password);

    // Set refresh token as HTTP-only cookie
    // res.cookie("refreshToken", result.tokens.refreshToken, {
    //   httpOnly: true,
    //   secure: process.env.NODE_ENV === "production",
    //   sameSite: "strict",
    //   maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
    // });

    res.setHeader("Set-Cookie", [
      `accessToken=${result.tokens.accessToken}; HttpOnly; Secure; SameSite=Strict; Path=/; Max-Age=3600`, // Expires in 1 hour
      `refreshToken=${result.tokens.refreshToken}; HttpOnly; Secure; SameSite=Strict; Path=/; Max-Age=604800`, // Expires in 7 days
    ]);

    res.json({
      user: result.user,
      accessToken: result.tokens.accessToken,
      refreshToken: result.tokens.refreshToken,
    });
  } catch (error) {
    next(error);
  }
};

exports.validateToken = async (req, res) => {
  const token = req.headers.authorization?.split(" ")[1];
  if (!token) return res.sendStatus(401);

  try {
    const decoded = verifyAccessToken(token); // throws if invalid
    console.log("Decoded token:", decoded); // ✅ add this for debugging
    res.sendStatus(204); // ✅ VERY IMPORTANT: No body
  } catch (err) {
    res.sendStatus(401);
  }
};

exports.refreshToken = async (req, res, next) => {
  try {
    const refreshToken = req.cookies.refreshToken || req.body.refreshToken;

    if (!refreshToken) {
      return res.status(400).json({ message: "Refresh token is required" });
    }

    const tokens = await authService.refreshToken(refreshToken);

    // Set new refresh token as HTTP-only cookie
    res.cookie("refreshToken", tokens.refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "strict",
      maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
    });

    res.json({ accessToken: tokens.accessToken });
  } catch (error) {
    next(error);
  }
};

exports.logout = async (req, res, next) => {
  try {
    const refreshToken = req.cookies.refreshToken || req.body.refreshToken;

    if (req.user && req.user.id) {
      await authService.logout(req.user.id, refreshToken);
    }

    // Clear refresh token cookie
    res.clearCookie("refreshToken");

    res.json({ message: "Logged out successfully" });
  } catch (error) {
    next(error);
  }
};

exports.logoutAll = async (req, res, next) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: "Authentication required" });
    }

    await authService.logoutAll(req.user.id);

    // Clear refresh token cookie
    res.clearCookie("refreshToken");

    res.json({ message: "Logged out from all devices successfully" });
  } catch (error) {
    next(error);
  }
};

exports.updateUser = async (req, res, next) => {
  try {
    const userId = req.params.id;
    const userData = req.body;

    // Basic validation
    if (!userId) {
      return res.status(400).json({ message: "User ID is required" });
    }
    if (Object.keys(userData).length === 0) {
      return res.status(400).json({ message: "No update data provided" });
    }

    const updatedUser = await authService.updateUser(userId, userData);
    res.json(updatedUser);
  } catch (error) {
    next(error);
  }
};

exports.deleteUser = async (req, res, next) => {
  try {
    const userId = req.params.id;

    if (!userId) {
      return res.status(400).json({ message: "User ID is required" });
    }

    await authService.deleteUser(userId);
    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    next(error);
  }
};
