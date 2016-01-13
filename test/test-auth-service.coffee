assert = require('assert')
chai = require('chai')
service = require('../app/services/auth-service')
chai.should()

describe 'O serviço de autenticação', ->
  it 'deve saber validar um token', (done)->
    service.verify null, (error, decoded)->
      error.should.have.property('message').which.contains('não enviado')
      done()
