const { pool } = require("../config/database");

async function uploadSkinImage(req, res) {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No image uploaded" });
    }

    const imagePath = req.file.path;
    
    const [result] = await pool.execute(
      "INSERT INTO skin_captures (image_path, captured_at) VALUES (?, NOW())",
      [imagePath]
    );

    console.log("Image saved to DB with ID:", result.insertId);

    return res.status(200).json({
      message: "Image uploaded and saved successfully",
      id: result.insertId,
      filePath: imagePath,
    });
  } catch (error) {
    console.error("Upload error:", error);
    return res.status(500).json({ message: "Internal server error during upload" });
  }
}

// Fetch all capture history from database
async function getSkinHistory(req, res) {
  try {
    const [rows] = await pool.execute(
      "SELECT * FROM skin_captures ORDER BY captured_at DESC"
    );
    
    // We modify the file path to be a full URL so the app can display it
    const historyWithUrls = rows.map(row => ({
      ...row,
      imageUrl: `http://${req.hostname}:3000/${row.image_path.replace(/\\/g, '/')}`
    }));

    return res.status(200).json(historyWithUrls);
  } catch (error) {
    console.error("History fetch error:", error);
    return res.status(500).json({ message: "Unable to fetch history" });
  }
}

module.exports = {
  uploadSkinImage,
  getSkinHistory,
};
