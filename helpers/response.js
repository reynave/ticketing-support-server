function success(message, data = null) {
  return {
    status: true,
    message,
    data,
  };
}

function failure(message, data = null) {
  return {
    status: false,
    message,
    data,
  };
}

function warning(message, data = null) {
  return {
    status: false,
    type: 'warning',
    message,
    data,
  };
}

module.exports = {
  success,
  failure,
  warning,
};
