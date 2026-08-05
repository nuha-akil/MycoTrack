require("dotenv").config();

const express = require("express");
const cors = require("cors");

const authRoutes = require("./routes/authRoutes");
const {
  testDatabaseConnection,
} = require("./config/database");

const app = express();
const port = Number(process.env.PORT || 3000);

// Development CORS configuration.
app.use(cors());

// Parse incoming JSON request bodies.
app.use(express.json());

// Health-check route.
app.get("/", (req, res) => {
  return res.status(200).json({
    success: true,
    message: "MycoTrack backend is running",
  });
});

// Authentication routes.
app.use("/api/auth", authRoutes);

// Handle unknown endpoints.
app.use((req, res) => {
  return res.status(404).json({
    success: false,
    message: "Endpoint not found",
  });
});

// General Express error handler.
app.use((error, req, res, next) => {
  console.error("Unhandled server error:", error);

  return res.status(500).json({
    success: false,
    message: "Internal server error",
  });
});

async function startServer() {
  try {
    await testDatabaseConnection();

    app.listen(port, "0.0.0.0", () => {
      console.log(`Server running at http://localhost:${port}`);
    });
  } catch (error) {
    console.error("Unable to start backend:", error.message);
    process.exit(1);
  }
}

startServer();