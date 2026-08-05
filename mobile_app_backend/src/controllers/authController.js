const bcrypt = require("bcryptjs");
const { pool } = require("../config/database");

function isValidEmail(email) {
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailPattern.test(email);
}

//Create new account control
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

//login control
async function loginUser(req, res) {
  try {
    const username =
      typeof req.body.username === "string"
        ? req.body.username.trim()
        : "";

    const password =
      typeof req.body.password === "string"
        ? req.body.password
        : "";

    if (!username || !password) {
      return res.status(400).json({
        success: false,
        message: "Username and password are required",
      });
    }

    const [users] = await pool.execute(
      `
        SELECT
          id,
          email,
          username,
          password_hash
        FROM users
        WHERE username = ?
        LIMIT 1
      `,
      [username]
    );

    if (users.length === 0) {
      return res.status(401).json({
        success: false,
        message: "Invalid username or password",
      });
    }

    const user = users[0];

    const passwordMatches = await bcrypt.compare(
      password,
      user.password_hash
    );

    if (!passwordMatches) {
      return res.status(401).json({
        success: false,
        message: "Invalid username or password",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Login successful",
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
      },
    });
  } catch (error) {
    console.error("Login error:", error);

    return res.status(500).json({
      success: false,
      message: "Unable to log in",
    });
  }
}

async function checkResetEmail(req, res) {
  try {
    const email =
      typeof req.body.email === "string"
        ? req.body.email.trim().toLowerCase()
        : "";

    if (!email) {
      return res.status(400).json({
        success: false,
        message: "Email address is required",
      });
    }

    const [users] = await pool.execute(
      `
        SELECT id, email, username
        FROM users
        WHERE LOWER(email) = ?
        LIMIT 1
      `,
      [email]
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Email address does not exist",
      });
    }

    const user = users[0];

    return res.status(200).json({
      success: true,
      message: "Email address verified",
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
      },
    });
  } catch (error) {
    console.error("Email check error:", error);

    return res.status(500).json({
      success: false,
      message: "Unable to check the email address",
    });
  }
}

async function resetPasswordDirectly(req, res) {
  try {
    const userId = Number(req.body.userId);

    const email =
      typeof req.body.email === "string"
        ? req.body.email.trim().toLowerCase()
        : "";

    const newPassword =
      typeof req.body.newPassword === "string"
        ? req.body.newPassword
        : "";

    if (
      !Number.isInteger(userId) ||
      userId <= 0 ||
      !email ||
      !newPassword
    ) {
      return res.status(400).json({
        success: false,
        message: "User, email, and password are required",
      });
    }

    if (newPassword.length < 8) {
      return res.status(400).json({
        success: false,
        message: "Password must contain at least 8 characters",
      });
    }

    const [users] = await pool.execute(
      `
        SELECT id, email, username
        FROM users
        WHERE id = ?
          AND LOWER(email) = ?
        LIMIT 1
      `,
      [userId, email]
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: "User account was not found",
      });
    }

    const passwordHash = await bcrypt.hash(
      newPassword,
      12
    );

    const [updateResult] = await pool.execute(
      `
        UPDATE users
        SET password_hash = ?
        WHERE id = ?
          AND LOWER(email) = ?
      `,
      [passwordHash, userId, email]
    );

    if (updateResult.affectedRows !== 1) {
      return res.status(500).json({
        success: false,
        message: "Password was not updated",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Password changed successfully",
      user: {
        id: users[0].id,
        email: users[0].email,
        username: users[0].username,
      },
    });
  } catch (error) {
    console.error("Password reset error:", error);

    return res.status(500).json({
      success: false,
      message: "Unable to change the password",
    });
  }
}

module.exports = {
  registerUser,
  loginUser,
  checkResetEmail,
  resetPasswordDirectly,
};