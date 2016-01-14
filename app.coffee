config = require './config'
express = require 'express'
bodyParser = require 'body-parser'
mongoose = require 'mongoose'
morgan = require 'morgan'
path = require 'path'
jwt = require 'jsonwebtoken'
bcrypt = require 'bcrypt-nodejs'


#Cria a aplicação Express e uma sub-aplicação responsável pela parte da API
mainApp = express()
api = express()

#Atribui a sub-aplicação ao endereço '/api'
mainApp.use '/api', api

#Configura a sub-aplicação para trabalhar com JSON
api.use bodyParser.urlencoded(extended: true)
api.use bodyParser.json()

#Configura cabeçalhos padrão para todas as respostas HTTP fornecidas pela aplicação
api.use (req, res, next) ->
	res.setHeader 'Access-Control-Allow-Origin', '*'
	res.setHeader 'Access-Control-Allow-Methods', 'GET, POST'
	res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type, Authorization'
	next()

#Inicializa a biblioteca de log para o ambiente de desenvolvimento
mainApp.use morgan 'dev'

#Realiza a conexão com o Banco de Dados de acordo com a string definida no arquivo config.coffee
mongoose.connect config.database

#Obtém modelos
Log = require('./app/models/log')(mongoose)
User = require('./app/models/user')(mongoose, bcrypt)

#Obtém serviços
authService = require('./app/services/auth-service')(User, jwt, config)
logService = require('./app/services/log-service')(Log, config)

#Inicializa rotas
logRoutes = require('./app/routes/log-routes')(express, logService)
api.use '/', logRoutes

authRoutes = require('./app/routes/auth-routes')(express, authService)
api.use '/', authRoutes

userRoutes = require('./app/routes/user-routes')(express)
api.use '/', userRoutes

#Inicia o servidor na porta informada pela linha de comando ou na padrão definida no arquivo config.coffee
mainApp.listen config.port
console.log 'Aplicação rodando na porta: ' + config.port