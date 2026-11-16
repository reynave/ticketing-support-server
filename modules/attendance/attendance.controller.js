const attendanceService = require('./attendance.service');
const { success, failure } = require('../../helpers/response');

async function list(req, res, next) {
  try {
    const data = await attendanceService.listAttendance(req.query || {});
    return res.json(success('Attendance list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function summary(req, res, next) {
  try {
    const data = await attendanceService.getAttendanceSummary(req.query || {});
    return res.json(success('Attendance summary fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function dashboard(req, res, next) {
  try {
    const data = await attendanceService.getAttendanceDashboard(req.query || {});
    return res.json(success('Attendance dashboard fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function status(req, res, next) {
  try {
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json(failure('Unauthorized'));
    }

    const data = await attendanceService.getCurrentStatus(userId);
    return res.json(success('Attendance status fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function myHistory(req, res, next) {
  try {
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json(failure('Unauthorized'));
    }

    const data = await attendanceService.getMyHistory(userId);
    return res.json(success('My attendance history fetched', data));
  } catch (error) {
    return next(error);
  }
}

function clientIp(req) {
  const forwarded = req.headers['x-forwarded-for'];
  if (forwarded) {
    const first = String(forwarded).split(',')[0].trim();
    if (first) {
      return first;
    }
  }
  return req.socket?.remoteAddress || null;
}

async function checkIn(req, res, next) {
  try {
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json(failure('Unauthorized'));
    }

    const body = req.body || {};
    const data = await attendanceService.checkIn(userId, {
      checkInLng: body.lng ?? body.checkInLng ?? null,
      checkInLat: body.lat ?? body.checkInLat ?? null,
      checkInIp: clientIp(req),
      checkInUserAgent: req.headers['user-agent'] || null,
      checkInAddress: body.address ?? body.checkInAddress ?? null,
    });

    return res.json(success('Check-in success', data));
  } catch (error) {
    return next(error);
  }
}

async function checkOut(req, res, next) {
  try {
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json(failure('Unauthorized'));
    }

    const body = req.body || {};
    const data = await attendanceService.checkOut(userId, {
      checkOutLng: body.lng ?? body.checkOutLng ?? null,
      checkOutLat: body.lat ?? body.checkOutLat ?? null,
      checkOutIp: clientIp(req),
      checkOutUserAgent: req.headers['user-agent'] || null,
      checkOutAddress: body.address ?? body.checkOutAddress ?? null,
    });

    return res.json(success('Check-out success', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
  summary,
  dashboard,
  status,
  myHistory,
  checkIn,
  checkOut,
};