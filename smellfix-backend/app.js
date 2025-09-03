require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const app = express();
const authRoutes = require('./routes/authRoutes');
const codefileRoutes = require('./routes/fileRoutes');
const analysisRoutes = require('./routes/analysisRoutes');
const historyRoutes = require('./routes/historyRoutes');

dotenv.config();

// Middleware
app.use(express.json());
app.use('/uploads', express.static('uploads'));
app.use('/api/uploads', codefileRoutes);
app.use('/api/analysis', analysisRoutes);

// MongoDB connection
mongoose.connect(process.env.MONGO_URI)
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.log(err));

app.use('/api/auth', authRoutes);
app.use('/uploads', express.static('uploads'));
app.use('/api/history', historyRoutes);

const port = process.env.PORT || 5000;
app.listen(port, () => console.log(`Server running on port ${port}`));