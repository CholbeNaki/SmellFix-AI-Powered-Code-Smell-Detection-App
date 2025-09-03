const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {

    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const fileFilter = (req, file, cb) => {
  const allowedImageTypes = /jpeg|jpg|png|gif/;
  const allowedCodeTypes = /py|java/;

  const extName = path.extname(file.originalname).toLowerCase();
  let mimeType = file.mimetype.toLowerCase();

  if (extName === '.py') {
    mimeType = 'application/python';
  } else if (extName === '.java') {
    mimeType = 'application/java';
  }

  if (allowedImageTypes.test(extName) && allowedImageTypes.test(mimeType)) {
    return cb(null, true);
  } else if (allowedCodeTypes.test(extName)) {
    return cb(null, true);  // Allow .py and .java files
  } else {
    return cb(new Error('Only code files (.py, .java) are allowed.'));
  }
};

const upload = multer({
  storage: storage,
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: fileFilter
});

module.exports = upload;
