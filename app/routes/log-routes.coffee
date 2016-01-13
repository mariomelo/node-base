Log = require '../models/log'

module.exports = (express, config) ->
  logRouter = express.Router()
  if config.logging
    logRouter.all '/*', (req, res, next) ->
      console.log req.body
      log = new Log
      log.date = new Date
      log.headers = req.headers
      log.ip = req.ip
      log.method = req.method
      log.url = req.originalUrl
      log.body = req.body
      log.params = req.params

      log.save (err) ->
        console.log err if err

      next()
  return logRouter

