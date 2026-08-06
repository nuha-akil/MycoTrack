require("dotenv").config();

const express = require("express");
const cors = require("cors");
const path = require("path");

const authRoutes = require("./routes/authRoutes");
const skinRoutes = require("./routes/skinRoutes");
const {
  testDatabaseConnection,
} = require("./config/database");

const app = express();
const PORT = Number(process.env.PORT || 3000);

app.use(cors());
app.use(express.json());

// Serve static files from uploads folder
app.use("/uploads", express.static(path.join(__dirname, "../uploads")));

app.get("/", (req, res) => {
  res.json({
    message: "MycoTrack backend is running",
  });
});

app.use("/api/auth", authRoutes);
app.use("/api/skin", skinRoutes);

async function startServer() {
  try {
    await testDatabaseConnection();

    app.listen(PORT, "0.0.0.0", () => {
      console.log(`Server running at http://0.0.0.0:${PORT}`);
    });
  } catch (error) {
    console.error("Failed to start server:", error.message);
    process.exit(1);
  }
}

startServer();
