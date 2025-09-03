const multer = require('multer');
const path = require('path');
const File = require('../models/fileModel');
const History = require('../models/historyModel');

// File storage configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

// Filter for allowed file types
const fileFilter = (req, file, cb) => {
  const allowedCodeTypes = /py|java/;
  const extName = path.extname(file.originalname).toLowerCase();
  const mimeType = file.mimetype.toLowerCase();

  // Allow only code files (.py, .java)
  if (allowedCodeTypes.test(extName)) {
    return cb(null, true);
  } else {
    return cb(new Error('Only code files (.py, .java) are allowed.'));
  }
};

// Max file size
const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter,
}).single('file');

// File upload controller
exports.uploadFile = (req, res) => {
  upload(req, res, async (err) => {
    if (err) {
      console.error('Multer Error:', err);
      return res.status(400).json({ msg: 'File upload failed', error: err.message });
    }

    const userId = req.user?.userId;
    if (!userId) {
      return res.status(400).json({ msg: 'User is not authenticated' });
    }

    // Create and save the history record
    const history = new History({
      fileName: req.file.originalname,
      filePath: req.file.path,
      analysisResult: {},  // Initially empty or placeholder data
      user:userId,
    });

    try {
      await history.save();
      res.status(200).json({ msg: 'File uploaded successfully', file: req.file, history });
    } catch (error) {
      console.error('Error saving history record:', error);
      res.status(500).json({ msg: 'Failed to save history', error: error.message });
    }
  });
};
