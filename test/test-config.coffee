assert = require('assert')
chai = require('chai')
config = require('../config')
chai.should()
describe 'O arquivo de configurações globais do serviço', ->
  it 'existe e está acessível', ->
    config.should.not.equal undefined
    return
  it 'contém uma string que define a conexão com o banco', ->
    config.should.have.property('database').and.not.equal ''
    return
  it 'possui uma palavra chave para o token de autenticação com mais de 18 caracteres', ->
    config.should.have.property('secret').with.length.above 18
    return
  return
