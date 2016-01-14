fake_user = 
  username: 'barack_obama'
  comparePassword: (password) -> user_mock.passwordCorrect  

user_mock =
  passwordCorrect: false
  user: fake_user
  getPasswordByUsername: (username, callback) -> callback user_mock.user

jwt_mock =
  tokenValid: false
  verify: (token, secret, callback) ->
    callback(null, username: "barack_obama") if user_mock.tokenValid
    callback("Token Rejeitado", null) unless user_mock.tokenValid
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
      user_mock.tokenValid = true
      service.verify 'token', (error, decoded)->
        decoded.should.have.property('username').which.equals 'barack_obama'
        done()

  describe 'O processo de autenticação', ->
    it 'deve barrar usuários inexistentes', (done) ->
      user_mock.user = null
      service.login 'teste', '', (result) ->
        result.success.should.be.false
        result.message.should.contain 'Usuário não encontrado'
        result.should.not.have.property 'token'
        done()

    it 'deve barrar senhas incorretas', (done)->
      user_mock.user = fake_user
      service.login 'teste', '', (result) ->
        result.success.should.be.false
        result.message.should.contain 'Senha incorreta'
        result.should.not.have.property 'token'
        done()

    it 'deve permitir usuários existentes com a senha correta', (done) ->
      user_mock.user = fake_user
      user_mock.passwordCorrect = true
      service.login 'teste', '', (result) ->
        result.success.should.be.true
        result.message.should.contain 'autenticado com sucesso'
        result.should.have.property 'token'
        done()
