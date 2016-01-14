#Pré condições do teste
tokenValid = false

user_mock = 
  result: null
  error: false
  findOne: () -> 
    console.log 'findOne'
    user_mock
  select: () -> 
    console.log 'select'
    user_mock
  exec: (callback) -> 
    callback user_mock.result

jwt_mock =
  verify: (token, secret, callback) ->
    callback(null, username: "barack_obama") if tokenValid
    callback("Token Rejeitado", null) unless tokenValid
  sign: -> 'token_fake'


#Serviço sendo "enganado" com um JWT de mentira
service = require('../app/services/auth-service')(user_mock, jwt_mock, secret: 'teste')

#Teste do método de verificação
describe 'AuthService', ->
  describe 'As rotas seguras', ->
    it 'devem exigir um token', (done)->
      service.verify null, (error, decoded)->
        error.should.have.property('message').which.contains('não enviado')
        done()
    it 'devem rejeitar tokens inválidos', (done) ->
      service.verify 'token', (error, decoded)->
        error.should.have.property('message').which.contains 'Token de autenticação inválido'
        done()

    it 'devem aceitar tokens válidos', (done) ->
      tokenValid = true
      service.verify 'token', (error, decoded)->
        decoded.should.have.property('username').which.equals 'barack_obama'
        done()

  describe 'O processo de autenticação', ->
    it 'deve barrar usuários inexistentes', (done) ->
      user_mock.result = null
      service.login 'teste', '', (result) ->
        result.success.should.be.false
        done()

    it 'deve barrar senhas incorretas'
    it 'deve permitir usuários existentes com a senha correta'
