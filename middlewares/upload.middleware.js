const multer = require('multer');
const path = require('path');
const fs = require('fs');

const uploadDir = path.join(__dirname, '..', 'uploads');

if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    const uniqueName = `${Date.now()}-${Math.round(Math.random() * 1e9)}${ext}`;
    cb(null, uniqueName);
  },
});

const fileFilter = (req, file, cb) => {
  const allowedMime = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
  const allowedExt = /\.(jpeg|jpg|png|gif|webp)$/i;

  const isMimeValid = allowedMime.includes(file.mimetype);
  const isExtValid = allowedExt.test(path.extname(file.originalname));

  if (isMimeValid && isExtValid) {
    cb(null, true);
  } else {
    cb(new Error(`File type not allowed: ${file.originalname}`));
  }
};

const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB
    files: 20,
  },
});

const runMiddleware = (req, res, fn) => {
  return new Promise((resolve, reject) => {
    fn(req, res, (err) => {
      if (err) reject(err);
      else resolve(null);
    });
  });
};

module.exports = { upload, runMiddleware };