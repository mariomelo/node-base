module.exports = (User, jwt, config) ->
  AuthService = 
    login: (username, password, callback) ->
      User.getPasswordByUsername username, (user) ->
        if !user
            callback success: false,
            message: 'Falha na autenticação: Usuário não encontrado'

        else
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

  return AuthService
