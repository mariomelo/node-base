User = require '../models/user'
jwt = require 'jsonwebtoken',
config = require '../../config'

module.exports = 
  login: (username, password, callback) ->
    User.findOne( username: username ).select('password').exec (error, user) ->
      throw error if error
      if !user
          callback success: false,
          message: 'Falha na autenticação: Usuário não encontrado'

      else if user
        validPassword = user.comparePassword(password)
        if !validPassword

            callback success: false,
            message: 'Falha na autenticação: Senha incorreta.'
          else
            token = jwt.sign({id: user._id, username: username}, config.secret, expiresInMinutes: 1440)
            
            callback success: true,
            message: 'Usuário autenticado com sucesso! Token emitido.',
            token: token
  verify: (token, callback) ->
    if !token
      callback message: 'Token de autenticação não enviado.'
    else jwt.verify token, config.secret, (error, decodedInfo) ->
      if error
        callback message: 'Token de autenticação inválido.'
      else
        callback null, decodedInfo
