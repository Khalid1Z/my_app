import express from "express";
import cors from "cors";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { v4 as uuid } from "uuid";

const app = express();
const PORT = process.env.PORT ?? 3000;
const API_TOKEN = process.env.API_TOKEN ?? "dev-token";

app.use(cors());
app.use(express.json());

const requireAuth = (req, res, next) => {
  const header = req.headers["authorization"] ?? "";
  if (!API_TOKEN) {
    return next();
  }
  if (header === `Bearer ${API_TOKEN}`) {
    return next();
  }
  return res.status(401).json({ message: "Unauthorized" });
};

const readJson = (relativePath) => {
  const currentDir = path.dirname(fileURLToPath(import.meta.url));
  const absolute = path.resolve(currentDir, relativePath);
  const content = fs.readFileSync(absolute, "utf-8");
  return JSON.parse(content);
};

const services = readJson("../my_app/assets/services.json");
const pros = readJson("../my_app/assets/pros.json");
let bookings = [];
const availability = {};

const seedAvailability = () => {
  const slotsPerPro = 10;
  pros.forEach((pro) => {
    availability[pro.id] = [];
    for (let i = 0; i < slotsPerPro; i += 1) {
      const date = new Date();
      date.setDate(date.getDate() + Math.floor(Math.random() * 7));
      date.setHours(9 + (i % 6), i % 2 === 0 ? 0 : 30, 0, 0);
      availability[pro.id].push(date.toISOString());
    }
  });
};
seedAvailability();

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

app.use(requireAuth);

app.get("/services", (req, res) => {
  res.json(services);
});

app.get("/services/:id", (req, res) => {
  const service = services.find((item) => item.id === req.params.id);
  if (!service) {
    return res.status(404).json({ message: "Service not found" });
  }
  return res.json(service);
});

app.get("/pros", (req, res) => {
  const { serviceId } = req.query;
  if (!serviceId) {
    return res.json(pros);
  }
  const filtered = pros.filter((pro) => pro.skills?.includes(serviceId));
  return res.json(filtered);
});

app.get("/pros/:id", (req, res) => {
  const pro = pros.find((item) => item.id === req.params.id);
  if (!pro) {
    return res.status(404).json({ message: "Professional not found" });
  }
  return res.json(pro);
});

app.get("/availability", (req, res) => {
  const { proId } = req.query;
  if (!proId || !availability[proId]) {
    return res.json([]);
  }
  return res.json(availability[proId]);
});

app.post("/bookings", (req, res) => {
  const payload = req.body ?? {};
  const id = uuid();
  const booking = {
    id,
    ...payload,
  };
  bookings.push(booking);
  res.status(201).json(booking);
});

app.get("/bookings", (req, res) => {
  res.json(bookings);
});

app.post("/wallet/charge", (req, res) => {
  const { amount, description } = req.body ?? {};
  if (typeof amount !== "number") {
    return res.status(400).json({ message: "Amount is required" });
  }
  return res.json({
    status: "ok",
    charged: amount,
    description,
  });
});

app.post("/reviews", (req, res) => {
  res.status(201).json({ status: "stored" });
});

app.post("/kyc/documents", (req, res) => {
  res.status(201).json({ status: "uploaded" });
});

app.post("/kyc/submit", (req, res) => {
  res.json({ status: "submitted" });
});

app.use((req, res) => {
  res.status(404).json({ message: "Not found" });
});

app.listen(PORT, () => {
  console.log(`API server listening on http://localhost:${PORT}`);
});
