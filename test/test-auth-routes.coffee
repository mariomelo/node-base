request = require 'supertest'
express = require 'express'
assert = require 'assert'

app = express()

service_mock =
  tokenValid: false
  verify: (token, callback) ->
    callback(null, username: "barack_obama") if service_mock.tokenValid
    callback("Token Rejeitado", null) unless service_mock.tokenValid

authRoutes = require('../app/routes/auth-routes')(express, service_mock)
app.use '/', authRoutes

describe 'AuthRoutes', ->
  describe 'O endereço "/" deve', ->
    it 'deve retornar uma mensagem amigável para qualquer usuário', (done)->
      request app
      .get '/'
      .expect 200
      , done
      
  describe 'Rota de Autenticação', ->
    it 'deve retornar 203 se o token for inválido', (done) ->
      request(app)
      .get '/teste'
      .expect 203
      , done
        
    it 'deve retornar 200 se o token for válido', (done) ->
      service_mock.tokenValid = true
      request(app)
      .get '/teste'
      .expect 200
      .end (error, result) ->
        result.body.success.should.be.true
        done(error)