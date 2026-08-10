const templateService = require('./template.service');

async function list(req, res, next) {
  try {
    const rows = await templateService.listTemplates(req.query || {});
    res.json({ success: true, data: rows });
  } catch (error) {
    next(error);
  }
}

async function detail(req, res, next) {
  try {
    const row = await templateService.getTemplateDetail(req.params.id);
    res.json({ success: true, data: row });
  } catch (error) {
    next(error);
  }
}

async function create(req, res, next) {
  try {
    const actorId = req.user?.id || req.body?.inputBy || 1;
    const row = await templateService.createTemplate(req.body || {}, actorId);
    res.status(201).json({ success: true, message: 'Template created', data: row });
  } catch (error) {
    next(error);
  }
}

async function update(req, res, next) {
  try {
    const actorId = req.user?.id || req.body?.inputBy || 1;
    const row = await templateService.updateTemplate(req.params.id, req.body || {}, actorId);
    res.json({ success: true, message: 'Template updated', data: row });
  } catch (error) {
    next(error);
  }
}

async function remove(req, res, next) {
  try {
    const actorId = req.user?.id || req.body?.inputBy || 1;
    const row = await templateService.deleteTemplate(req.params.id, actorId);
    res.json({ success: true, message: 'Template deleted', data: row });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  list,
  detail,
  create,
  update,
  remove,
};
