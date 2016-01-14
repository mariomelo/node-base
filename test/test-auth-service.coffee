#Pré condições do teste
tokenValid = false
jwt_mock =
  verify: (token, secret, callback) ->
    console.log "Método chamado! Token válido? " + tokenValid
    callback(null, username: "barack_obama") if tokenValid
    callback("Token Rejeitado", null) unless tokenValid

#Serviço sendo "enganado" com um JWT de mentira
service = require('../app/services/auth-service')(null, jwt_mock, secret: 'teste')

#Teste do método de verificação
describe 'O serviço de autenticação', ->
  it 'deve exigir um token', (done)->
    service.verify null, (error, decoded)->
      error.should.have.property('message').which.contains('não enviado')
      done()
  it 'deve rejeitar tokens inválidos', (done) ->
    service.verify 'token', (error, decoded)->
      error.should.have.property('message').which.contains 'Token de autenticação inválido'
      done()

  it 'deve aceitar tokens válidos', (done) ->
    tokenValid = true
    service.verify 'token', (error, decoded)->
      decoded.should.have.property('username').which.equals 'barack_obama'
      done()
