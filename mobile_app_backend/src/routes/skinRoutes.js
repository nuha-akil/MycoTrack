const express = require("express");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const skinController = require("../controllers/skinController");

const router = express.Router();

const uploadDir = "uploads/skin_captures";
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, file.fieldname + "-" + uniqueSuffix + path.extname(file.originalname));
  },
});

const upload = multer({ storage: storage });

// Routes
router.post("/upload", upload.single("skin_image"), skinController.uploadSkinImage);
router.get("/history", skinController.getSkinHistory); // NEW: Get all past captures

module.exports = router;
