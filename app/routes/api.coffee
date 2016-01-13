authService = require '../services/auth-service'

module.exports = (express, config, jwt) ->
  apiRouter = express.Router()
  console.log 'Api Router configurado'

  apiRouter.post '/auth', (req, res) ->
    authService.login req.body.username, req.body.password, (message)->
      res.json message
    
  apiRouter.use (req, res, next) -> 
      token = req.body.token or req.query.token or req.headers['x-access-token']
      
      if token
        jwt.verify token, config.secret, (err, decoded) ->
          if err
            res.status(203).send
              success: false
              message: 'Token inválido.'
          else
            req.decoded = decoded
            next()
            return
      else
        res.status(203).send
            success: false
            message: 'Token de identificação não fornecido.'
      return

  apiRouter.get '/teste', (req, res) ->
    res.json
      success: true
      message: 'Você acessou uma sessão segura de nossa API! Seja bem-vindo(a) ' + req.decoded.username

  return apiRouter