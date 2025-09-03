const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  dob: { type: Date, required: true },
  bio: { type: String, default: ''},
  image: { type: String, default: ''}, // store image path or URL
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);