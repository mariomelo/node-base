service = require('../app/services/auth-service')

describe 'O serviço de autenticação', ->
  it 'deve exigir um token', (done)->
    service.verify null, (error, decoded)->
      error.should.have.property('message').which.contains('não enviado')
      done()
  it 'deve rejeitar tokens inválidos'
  it 'deve aceitar tokens válidos'
