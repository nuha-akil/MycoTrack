const bcrypt = require("bcryptjs");
const { pool } = require("../config/database");

function isValidEmail(email) {
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailPattern.test(email);
}

async function registerUser(req, res) {
  try {
    const email =
      typeof req.body.email === "string"
        ? req.body.email.trim().toLowerCase()
        : "";

    const username =
      typeof req.body.username === "string"
        ? req.body.username.trim()
        : "";

    const password =
      typeof req.body.password === "string"
        ? req.body.password
        : "";

    // Validate required fields.
    if (!email || !username || !password) {
      return res.status(400).json({
        success: false,
        message: "Email, username, and password are required",
      });
    }

    if (!isValidEmail(email)) {
      return res.status(400).json({
        success: false,
        message: "Enter a valid email address",
      });
    }

    if (email.length > 255) {
      return res.status(400).json({
        success: false,
        message: "Email address is too long",
      });
    }

    if (username.length < 3) {
      return res.status(400).json({
        success: false,
        message: "Username must contain at least 3 characters",
      });
    }

    if (username.length > 100) {
      return res.status(400).json({
        success: false,
        message: "Username must not exceed 100 characters",
      });
    }

    if (password.length < 8) {
      return res.status(400).json({
        success: false,
        message: "Password must contain at least 8 characters",
      });
    }

    // Check both email and username.
    const [existingUsers] = await pool.execute(
      `
        SELECT id, email, username
        FROM users
        WHERE email = ? OR username = ?
        LIMIT 1
      `,
      [email, username]
    );

    if (existingUsers.length > 0) {
      const existingUser = existingUsers[0];

      if (existingUser.email === email) {
        return res.status(409).json({
          success: false,
          message: "An account with this email already exists",
        });
      }

      return res.status(409).json({
        success: false,
        message: "This username is already taken",
      });
    }

    // Hash the password before storing it.
    const passwordHash = await bcrypt.hash(password, 12);

    const [result] = await pool.execute(
      `
        INSERT INTO users (
          email,
          username,
          password_hash
        )
        VALUES (?, ?, ?)
      `,
      [email, username, passwordHash]
    );

    return res.status(201).json({
      success: true,
      message: "Account created successfully",
      user: {
        id: result.insertId,
        email,
        username,
      },
    });
  } catch (error) {
    console.error("Registration error:", error);

    if (error.code === "ER_DUP_ENTRY") {
      return res.status(409).json({
        success: false,
        message: "Email or username is already registered",
      });
    }

    return res.status(500).json({
      success: false,
      message: "Unable to create the account",
    });
  }
}

module.exports = {
  registerUser,
};