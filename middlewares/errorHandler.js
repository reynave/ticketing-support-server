const { failure } = require('../helpers/response');

function errorHandler(error, req, res, next) {
  if (res.headersSent) {
    return next(error);
  }

  const statusCode = error.statusCode || 500;
  const message = error.message || 'Internal server error';

  return res.status(statusCode).json(failure(message, error.details || null));
}

module.exports = errorHandler;
