config = require './config'
express = require 'express'
bodyParser = require 'body-parser'
mongoose = require 'mongoose'
morgan = require 'morgan'
path = require 'path'
jwt = require 'jsonwebtoken'

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

apiRoutes = require('./app/routes/api')(express, config, jwt)
app.use '/api', apiRoutes
	
app.listen config.port

console.log 'Aplicação rodando na porta: ' + config.port