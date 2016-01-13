authService = require '../services/auth-service'

module.exports = (express, config, jwt) ->
  authRouter = express.Router()
  console.log 'Auth Router configurado'

  authRouter.get '/', (req, res) ->
    res.json
      succes: true
      message: 'Bem vindo à API! Esse é o único endereço da aplicação que você pode acessar sem um token'

  authRouter.post '/auth', (req, res) ->
    authService.login req.body.username, req.body.password, (message)->
      res.json message
    
  authRouter.use (req, res, next) -> 
    token = req.body?.token or req.query?.token or req.headers['x-access-token']
    authService.verify token, (error, decoded) ->
      if error
        res.status(203).send
          success: false
          message: error.message
      else
        req.decoded = decoded
        next()        
    return

  authRouter.get '/teste', (req, res) ->
    res.json
      success: true
      message: 'Você acessou uma sessão segura de nossa API! Seja bem-vindo(a) ' + req.decoded.username

  return authRouter