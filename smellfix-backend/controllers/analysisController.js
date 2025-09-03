const fs = require('fs');
const analyzer = require('../utils/analyzer');
const History = require('../models/historyModel');
const path = require('path');

exports.analyzeFile = async (req, res) => {
  try {
    const { historyId } = req.body;
    const history = await History.findById(historyId);

    if (!history) {
      return res.status(404).json({ message: 'File history not found' });
    }

    const filePath = history.filePath;
    const fileName = history.fileName;
    const fileContent = fs.readFileSync(filePath, 'utf8');
    const fileExtension = path.extname(fileName).slice(1);
    const analysisResults = analyzer.analyzeFile(fileContent, `.${fileExtension}`);

    // Update the history record with the analysis result
    history.issues = analysisResults;
    await history.save();

    res.status(200).json({
      filename: history.fileName,
      message: 'File analyzed successfully',
      issues: analysisResults,
    });
  } catch (error) {
    console.error('Error during file analysis:', error);
    res.status(500).json({ message: 'Error analyzing the file', error: error.message });
  }
};
