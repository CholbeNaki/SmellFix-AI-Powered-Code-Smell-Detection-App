const History = require('../models/historyModel'); // Assuming the History model is in this path

// Save analysis results into the history collection
exports.saveToHistory = async (req, res, next) => {
  try {
    const userId = req.user.userId;
    const filePath=req.file.path
    const fileName=req.file.originalname

    const newHistory = new History({
      user: userId,
      fileName: fileName,
      filePath: filePath,
      issues: [],
    });

    await newHistory.save();

    res.locals.historyId = newHistory._id;
    
    next();
  } catch (error) {
    res.status(500).json({ message: 'Error saving analysis to history', error: error.message });
  }
};