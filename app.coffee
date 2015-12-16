config = require './config'
express = require 'express'
bodyParser = require 'body-parser'
mongoose = require 'mongoose'
morgan = require 'morgan'
path = require 'path'

app = express()

app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()

app.use (req, res, next) ->
	res.setHeader 'Access-Control-Allow-Origin', '*'
	res.setHeader 'Access-Control-Allow-Methods', 'GET, POST'
	res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type, Authorization'
	next()


app.use morgan 'dev'

mongoose.connect config.database

app.use express.static __dirname + '/public'

apiRoutes = require('./app/routes/api')(app, express);
app.use '/api', apiRoutes




app.get '*', (req, res) ->
	res.sendFile path.join __dirname + '/public/app/views/index.html'
	
app.listen config.port

console.log config.port + 'is the magic port!'