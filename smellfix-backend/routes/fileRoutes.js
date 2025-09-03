const express = require('express');
const fileController = require('../controllers/fileController');
const historyController = require('../controllers/historyController');
const authMiddleware = require('../middlewares/authMiddleware');

const router = express.Router();

// File upload route
router.post('/upload-file', authMiddleware, fileController.uploadFile, historyController.saveToHistory, (req, res) => {
  res.status(200).json({
    msg: 'File uploaded and saved to history successfully',
    historyId: res.locals.historyId,
  });
});

module.exports = router;
