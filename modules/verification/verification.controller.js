const verificationService = require('./verification.service');
const { success } = require('../../helpers/response');

function parseId(id) {
  if (!id || !String(id).trim()) {
    const error = new Error('Invalid id parameter');
    error.statusCode = 400;
    throw error;
  }

  return String(id).trim();
}

async function list(req, res, next) {
  try {
    const filters = { ...(req.query || {}) };
    const data = await verificationService.listVerification(filters);
    return res.json(success('Verification list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await verificationService.getVerificationDetail(id);
    return res.json(success('Verification detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function updateStatus(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const action = String(req.body?.action || '').trim().toLowerCase();

    if (action !== 'close' && action !== 'cancel') {
      const error = new Error("action must be 'close' or 'cancel'");
      error.statusCode = 400;
      throw error;
    }

    const updateBy = req.user?.id ? String(req.user.id) : '';
    const data = await verificationService.updateVerificationStatus(id, action, updateBy);
    return res.json(
      success(
        action === 'cancel' ? 'Case cancelled' : 'Case closed',
        data
      )
    );
  } catch (error) {
    return next(error);
  }
}

async function bulkUpdateStatus(req, res, next) {
  try {
    const ids = req.body?.ids;
    const action = req.body?.action;
    const updateBy = req.user?.id ? String(req.user.id) : '';

    const data = await verificationService.bulkUpdateVerificationStatus(
      ids,
      action,
      updateBy
    );

    return res.json(
      success(
        `${data.updated} of ${data.total} case(s) updated to ${data.ticketStatusName || data.ticketStatusId}`,
        data
      )
    );
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
  detail,
  updateStatus,
  bulkUpdateStatus,
};