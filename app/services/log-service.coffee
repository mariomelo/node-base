module.exports = (Log, config) ->
	LogService =
		logRequest: (req)->
			if config.logging is on
				log = new Log
				log.date = new Date
				log.headers = req.headers
				log.ip = req.ip
				log.method = req.method
				log.url = req.originalUrl
				log.body = req.body
				log.params = req.params

				log.save (err) ->
				  throw err if err

	return LogService