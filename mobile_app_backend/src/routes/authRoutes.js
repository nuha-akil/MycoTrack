const express = require("express");

const {
  registerUser,
  loginUser,
  checkResetEmail,
  resetPasswordDirectly,
} = require("../controllers/authController");

const router = express.Router();

router.post("/register", registerUser);
router.post("/login", loginUser);
router.post("/check-reset-email", checkResetEmail);
router.post(
  "/reset-password-direct",
  resetPasswordDirectly
);

module.exports = router;