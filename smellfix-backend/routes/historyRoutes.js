const express = require('express');
const History = require('../models/historyModel');
const authMiddleware = require('../middlewares/authMiddleware');

const router = express.Router();

// Fetch history
router.get('/', authMiddleware, async (req, res) => {
  try {
    const historyItems = await History.find({ user: req.user.userId }).sort({ createdAt: -1 });
    res.status(200).json(historyItems);
  } catch (error) {
    res.status(500).json({ message: 'Failed to fetch history items', error: error.message });
  }
});


// Delete
router.delete('/:id', authMiddleware, async (req, res) => {
  try {
    const historyItem = await History.findById(req.params.id);

    if (!historyItem) {
      return res.status(404).json({ message: 'History item not found' });
    }

    if (historyItem.user.toString() !== req.user.userId) {
      return res.status(403).json({ message: 'Unauthorized' });
    }

    await History.findByIdAndDelete(req.params.id);
    res.status(200).json({ message: 'History item deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Failed to delete history item', error: error.message });
  }
});


// Rename
router.put('/rename/:id', authMiddleware, async (req, res) => {
  const { newFileName } = req.body;

  if (!newFileName) {
    return res.status(400).json({ message: 'New file name is required' });
  }

  try {
    const historyItem = await History.findById(req.params.id);

    if (!historyItem) {
      return res.status(404).json({ message: 'History item not found' });
    }

    if (historyItem.user.toString() !== req.user.userId) {
      return res.status(403).json({ message: 'Unauthorized' });
    }

    historyItem.fileName = newFileName;

    await historyItem.save();
    res.status(200).json({
      message: 'File name updated successfully',
      updatedHistoryItem: historyItem,
    });
  } catch (error) {
    res.status(500).json({
      message: 'Failed to rename history item',
      error: error.message,
    });
  }
});

// View
router.get('/:id', authMiddleware, async (req, res) => {
  try {
    const historyItem = await History.findById(req.params.id);

    if (!historyItem) {
      return res.status(404).json({ message: 'History item not found' });
    }

    if (historyItem.user.toString() !== req.user.userId) {
      return res.status(403).json({ message: 'Unauthorized' });
    }

    res.status(200).json(historyItem);
  } catch (error) {
    res.status(500).json({ message: 'Failed to fetch history item', error: error.message });
  }
});

module.exports = router;
