const express = require("express");
const env = require("./src/environment");
const natsMgr = require("./src/utils/natsConnectionManager");
const restaurantRoutes = require("./src/routes/restaurantRoutes");
const workDayRoutes = require("./src/routes/workDayRoutes");
const workHoursRoutes = require("./src/routes/workHoursRoutes");
const scheduleRoutes = require("./src/routes/restaurantScheduleRoutes");
const foodItemRoutes = require("./src/routes/foodItemRoutes");
const orderRoutes = require("./src/routes/restaurantOrderRoutes");
const errorHandler = require("./src/middlewares/errorHandler");
const cors = require("cors");


async function start() {
  const app = express();
  app.use(express.json());
  // await natsMgr.connect(); // load subscriber

  app.use(
    cors({
      origin: "http://localhost:5174",
      credentials: true,
    })
  );

  // Health check endpoint
  app.get("/health", (req, res) => {
    // You could enhance this later to check DB connectivity too
    res.status(200).send("OK");
  });

  app.use("/api/restaurant", restaurantRoutes);
  app.use("/api/restaurant/work-days", workDayRoutes);
  app.use("/api/restaurant/work-hours", workHoursRoutes);
  app.use("/api/restaurant/schedules", scheduleRoutes);
  app.use("/api/restaurant/menu", foodItemRoutes);
  app.use("/api/restaurant/orders", orderRoutes);
  app.use(errorHandler);
  app.listen(env.PORT, () => console.log(`Listening on ${env.PORT}`));
}

start().catch((e) => {
  console.error(e);
  process.exit(1);
});
