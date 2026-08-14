const adminReportService = require('./admin-report.service');
const { success } = require('../../helpers/response');

async function taskReport(req, res, next) {
    try {
        const filters = { ...(req.query || {}) };
        const data = await adminReportService.listClosedTasks(filters);
        return res.json(success('Task report fetched', data));
    } catch (error) {
        return next(error);
    }
}
async function caseReport(req, res, next) {
    try {
        const filters = { ...(req.query || {}) };
        const data = await adminReportService.listClosedCases(filters);
        return res.json(success('Case report fetched', data));
    } catch (error) {
        return next(error);
    }
}
async function ticketDetail(req, res, next) {
    try {
        const ticketId = req.query.id;
        const data = await adminReportService.ticketDetail(ticketId);
        return res.json(success('Ticket details fetched', data));
    }
    catch (error) {
        return next(error);
    }
}

module.exports = {
    taskReport,
    caseReport,
    ticketDetail,
};
