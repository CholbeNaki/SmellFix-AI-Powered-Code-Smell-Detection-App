const express = require('express');
const analysisController = require('../controllers/analysisController');
const authMiddleware = require('../middlewares/authMiddleware');
const router = express.Router();

// Route to analyze a file using the historyId
router.post('/analyze', authMiddleware, analysisController.analyzeFile);

module.exports = router;
