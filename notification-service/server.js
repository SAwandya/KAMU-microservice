const express = require("express");
const nodemailer = require("nodemailer");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
const PORT = 7000;

app.use(cors());
app.use(bodyParser.json());

// Email transporter setup (using Gmail)
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "sachilaawandya@gmail.com", // ✅ Replace with your email
    pass: "twio jaro vdpg hixw", // ✅ Use an App Password, NOT your main password
  },
});

// Health check endpoint
app.get('/health', (req, res) => {
  // You could enhance this later to check DB connectivity too
  res.status(200).send('OK');
});

// POST endpoint to send email
app.post("/api/notification/send-email", async (req, res) => {
  const { to, subject, text } = req.body;

  try {
    await transporter.sendMail({
      from: 'sachilaawandya@gmail.com', // Sender address
      to,
      subject,
      text,
    });

    res.status(200).json({ message: "Email sent successfully" });
  } catch (err) {
    console.error("Email send error:", err);
    res.status(500).json({ error: "Failed to send email" });
  }
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
