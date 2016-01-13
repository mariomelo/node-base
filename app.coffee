config = require './config'
express = require 'express'
bodyParser = require 'body-parser'
mongoose = require 'mongoose'
morgan = require 'morgan'
path = require 'path'
jwt = require 'jsonwebtoken'

mainApp = express()
api = express()
mainApp.use '/api', api

mainApp.use bodyParser.urlencoded(extended: true)
mainApp.use bodyParser.json()

mainApp.use (req, res, next) ->
	res.setHeader 'Access-Control-Allow-Origin', '*'
	res.setHeader 'Access-Control-Allow-Methods', 'GET, POST'
	res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type, Authorization'
	next()

mainApp.use morgan 'dev'

mongoose.connect config.database

authRoutes = require('./app/routes/auth-routes')(express, config, jwt)
api.use '/', authRoutes

userRoutes = require('./app/routes/user-routes')(express)
api.use '/', userRoutes

mainApp.listen config.port

console.log 'Aplicação rodando na porta: ' + config.port