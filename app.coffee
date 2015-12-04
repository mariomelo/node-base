express = require 'express'
mongoose = require 'mongoose'
morgan = require 'morgan'
bodyParser = require 'body-parser'
User = require './app/model/user'


port = 1337 unless process.env.PORT is on

app = express()

mongoose.connect 'mongodb://meanbook:facta@ds061984.mongolab.com:61984/meanbook'



app.use bodyParser.urlencoded extended: true

app.use bodyParser.json()

app.use (req, res, next) ->
	res.setHeader 'Access-Control-Allow-Origin', '*'
	res.setHeader 'Access-Control-Allow-Methods', 'GET, POST'
	res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type, Authorization'
	next()

app.use morgan 'dev'

app.get '/', (req, res) ->
	res.send 'Welcome to our Home Page'

apiRouter = express.Router()

apiRouter.use (req, res, next) ->
	console.log 'Alguma coisa aconteceu, e nós vamos ignorar'
	next()

apiRouter.get '/', (req, res) ->
	res.json message: 'Welcome to our API'

apiRouter.route('/users').post (req, res) ->
  
  user = new User
  
  user.name = req.body.name
  user.username = req.body.username
  user.password = req.body.password
  
  user.save (err) ->
    if err
      if err.code == 11000
        return res.json(
          success: false
          message: 'A user with thatusername already exists. ')
      else
        return res.send(err)
    res.json message: 'User created!'
    return
  return

 .get (req, response) ->
 	User.find (error, users) ->
 		response.send error if error
 		response.json users

apiRouter.route('/users/:user_id')
.get (req, res) ->
	User.findById req.params.user_id, (error, user) ->
		res.send error if error
		res.json user
.put (req, res) ->
	User.findById req.params.user_id, (error, user) ->
		res.send error if error

		updateFields = ['name', 'username', 'password']
		
		user[field] = req.body[field] for field in updateFields

		user.save (error) ->
			res.send error if error
			res.json	
				message: 'User updated!'

.delete (req, res) ->
	User.remove _id: req.params.user_id, (error, user) ->
		return error if error
		res.json message: 'User removed!'



app.use '/api', apiRouter

app.listen port

# mongoose.connect 'mongodb://localhost/mean'
console.log port + 'is the magic port!'