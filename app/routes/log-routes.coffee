Log = require '../models/log'

module.exports = (express, logService) ->
  logRouter = express.Router()
  logRouter.all '/*', (req, res, next) ->
    logService.logRequest req
    next()
  return logRouter

