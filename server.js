require('dotenv').config();

const http = require('http');
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const { Server } = require('socket.io');
const { success } = require('./helpers/response');
const authRoutes = require('./modules/auth/auth.route');
const masterRoutes = require('./modules/master/master.route');
const clientRoutes = require('./modules/client/client.route');
const projectRoutes = require('./modules/project/project.route');
const userRoutes = require('./modules/user/user.route');
const ticketBalanceRoutes = require('./modules/ticket-balance/ticket-balance.route');
const errorHandler = require('./middlewares/errorHandler');
const { testConnection } = require('./config/db');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
  },
});

app.use(helmet());
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json(success('Server is running', { uptime: process.uptime() }));
});

app.use('/api/auth', authRoutes);
app.use('/api/master', masterRoutes);
app.use('/api/client', clientRoutes);
app.use('/api/project', projectRoutes);
app.use('/api/user', userRoutes);
app.use('/api/ticket-balance', ticketBalanceRoutes);

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
