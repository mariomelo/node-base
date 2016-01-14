module.exports = (mongoose, bcrypt) ->
  Schema = mongoose.Schema
  UserSchema = new Schema(
    name: String
    username:
      type: String
      required: true
      index: unique: true
    password:
      type: String
      required: true
      select: false)

  UserSchema.pre 'save', (next)->
  	user = this
  	return next() if user.isModified('password') is false
  	bcrypt.hash user.password, null, null, (error, hash) ->
  		return next error if error
  		user.password = hash
  		next()

  #Métodos de instância
  UserSchema.methods.comparePassword = (password) ->
  	user = this
  	bcrypt.compareSync password, user.password 

  #Métodos estáticos
  UserSchema.statics.getPasswordByUsername = (username, callback) ->
    this.findOne( username: username ).select('password').exec (error, user) ->
      throw error if error
      callback user

  return mongoose.model 'User', UserSchema