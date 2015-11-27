express = require 'express'
mongoose = require 'mongoose'
morgan = require 'morgan'
bodyParser = require 'body-parser'

port = 1337 unless process.env.PORT is on

app = express()

app.use bodyParser.urlencoded extended: true

app.use bodyParser.json()

app.use (req, res, next) ->
	res.setHeader 'Access-Control-Allow-Origin', '*'
	res.setHeader 'Access-Control-Allow-Methods', 'GET, POST'
	res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type, Authorization'
	next()

app.use morgan 'dev'

app.get '/', (req, res) ->
	res.send 'Welcome to our Home Page'

apiRouter = express.Router()

apiRouter.get '/', (req, res) ->
	res.json message: 'Welcome to our API'

app.use '/api', apiRouter

app.listen port

# mongoose.connect 'mongodb://localhost/mean'
console.log port + 'is the magic port!'