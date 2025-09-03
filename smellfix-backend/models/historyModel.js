const mongoose = require('mongoose');

const historySchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'user',
    required: true,
  },
  fileName: {type: String,required: true,},
  filePath: { type: String, required: true },
  issues: [
    {
      type: {
        type: String,
        required: true,
      },
      message: {
        type: String,
        required: true,
      },
      line: {
        type: Number,
      },
      suggestion: {
        type: String,
      },
    },
  ],
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const History = mongoose.model('History', historySchema);

module.exports = History;