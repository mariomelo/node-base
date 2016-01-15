chai = require 'chai'

saved_log = null

log_mock = ->
  error_on_save: true
  save: (callback) ->
    if log_mock.error_on_save
      callback new Error
      return
    else
      saved_log = this
      callback()

config_mock =
  logging: on

request = 
  headers: 'Mocked Headers'
  ip: '127.0.0.22'
  method: 'DELETE'
  originalUrl: 'http://facta.works/'
  body: 'um json qualquer'
  params: 'um outro json'

service = require('../app/services/log-service')(log_mock, config_mock)

describe 'LogService', ->
  describe 'O serviço de log', ->
    it 'deve salvar as informações da requisição no log', ->
      service.logRequest request
      chai.expect(-> service.logRequest request).not.to.throw()
      request.ip.should.be.equal saved_log.ip
      request.originalUrl.should.be.equal saved_log.url

    it 'deve lançar uma exceção caso não consiga salvar o dado no banco', ->
      log_mock.error_on_save = true
      chai.expect(-> service.logRequest request).to.throw()

    it 'não deve salvar logs caso esteja configurado para tal', ->
      config_mock.logging = off
      saved_log = null
      chai.expect(-> service.logRequest request).not.to.throw()
      chai.expect(saved_log).to.be.equal null


