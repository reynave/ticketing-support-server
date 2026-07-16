const fs = require('fs');
const logStream = fs.createWriteStream('./app.log', { flags: 'a' });
const originalStdoutWrite = process.stdout.write.bind(process.stdout);
const originalStderrWrite = process.stderr.write.bind(process.stderr);

process.stdout.write = (chunk, encoding, callback) => {
  logStream.write(chunk, encoding);
  return originalStdoutWrite(chunk, encoding, callback);
};

process.stderr.write = (chunk, encoding, callback) => {
  logStream.write(chunk, encoding);
  return originalStderrWrite(chunk, encoding, callback);
};

require('dotenv').config();
const PREFIX_SERVER = process.env.PREFIX_SERVER || '/api';

const http = require('http');
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const { Server } = require('socket.io');
const { success } = require('./helpers/response');
const authRoutes = require('./modules/auth/auth.route');
const masterRoutes = require('./modules/master/master.route');
const ticketCategoriesRoutes = require('./modules/ticket-categories/ticket-categories.route');
const clientRoutes = require('./modules/client/client.route');
const projectRoutes = require('./modules/project/project.route');
const ticketRoutes = require('./modules/ticket/ticket.route');
const caseRoutes = require('./modules/cases/case.route');
const ratingRoutes = require('./modules/rating/rating.route');
const userRoutes = require('./modules/user/user.route');
const userLoginHistoryRoutes = require('./modules/user-login-history/user-login-history.route');
const ticketBalanceRoutes = require('./modules/ticket-balance/ticket-balance.route');
const errorHandler = require('./middlewares/errorHandler');
const { testConnection } = require('./config/db');
const path = require('path'); 
const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
  },
});

// Auto-create uploads folder
const uploadDir = path.join(__dirname, 'uploads');     // ← tambah
if (!fs.existsSync(uploadDir)) {                       // ← tambah
  fs.mkdirSync(uploadDir, { recursive: true });        // ← tambah
}     

app.use(helmet());
app.use(cors());
app.use(express.json());

// Tambahkan ini khusus untuk folder uploads
app.use('/uploads', (req, res, next) => {
  res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
  next();
});
app.use('/uploads', express.static(uploadDir));

app.get(`${PREFIX_SERVER}`, (req, res) => {
  res.json(success('Server is running', { uptime: process.uptime() }));
});
 
app.use(`${PREFIX_SERVER}/auth`, authRoutes);
app.use(`${PREFIX_SERVER}/master`, masterRoutes);
app.use(`${PREFIX_SERVER}/ticket-categories`, ticketCategoriesRoutes);
app.use(`${PREFIX_SERVER}/client`, clientRoutes);
app.use(`${PREFIX_SERVER}/project`, projectRoutes); 
app.use(`${PREFIX_SERVER}/ticket`, ticketRoutes);
app.use(`${PREFIX_SERVER}/cases`, caseRoutes);
app.use(`${PREFIX_SERVER}/rating`, ratingRoutes);
app.use(`${PREFIX_SERVER}/user`, userRoutes);
app.use(`${PREFIX_SERVER}/user-login-history`, userLoginHistoryRoutes);
app.use(`${PREFIX_SERVER}/ticket-balance`, ticketBalanceRoutes);

app.use(errorHandler);

io.on('connection', (socket) => {
  socket.emit('connected', { status: true, message: 'Socket connected' });
});

const port = Number(process.env.PORT || 3000);

testConnection()
  .then(() => {
    server.listen(port, () => {
      console.log(`Server listening on port ${port}`);
    });
  })
  .catch((error) => {
    console.error('Database connection failed:', error.message);
    process.exit(1);
  });
