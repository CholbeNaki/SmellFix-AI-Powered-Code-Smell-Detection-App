const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/userModel');
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage: storage }).single('photo');

// Login Controller
exports.login = async (req, res) => {
  const { username, password } = req.body;
  
  try {
    let user = await User.findOne({ username });
    
    if (!user) {
      return res.status(400).json({ msg: 'Invalid credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ msg: 'Invalid credentials' });
    }

    const payload = { userId: user.id };
    const token = jwt.sign(payload, 'your_jwt_secret', { expiresIn: '8h' });

    res.status(200).json({ token }); 
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

//SignUp Controller
exports.signup = async (req, res) => {
  const { name, password, username, bio, dob } = req.body;

  try {
    let user = await User.findOne({ username });
    if (user) {
      return res.status(400).json({ msg: "Username already exists" });
    }

    //Hasher
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    user = new User({
      name,
      password: hashedPassword,
      username,
      bio,
      dob,
      photo: req.file ? req.file.path : null,
    });

    await user.save();

    const payload = { userId: user.id };
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.status(201).json({ token });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};