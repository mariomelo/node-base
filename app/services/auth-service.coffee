module.exports =
  login: (username, password) ->
    result = {}
    User.findOne( username: username ).select('password').exec (error, user) ->
      throw error if error
      if !user
          result =
            success: false
            message: 'Falha na autenticação: Usuário não encontrado'
      else if user
        validPassword = user.comparePassword(password)
        if !validPassword
            res.json
                success: false
                message: 'Falha na autenticação: Senha incorreta.'
          else
            token = jwt.sign(user, config.secret, expiresInMinutes: 1440)
            res.json
              success: true
              message: 'Usuário autenticado com sucesso! Token emitido.'
              token: token