# Aplicação base para a criação de uma API utilizando NodeJS

A aplicação utiliza tokens JWT para validar o acesso à API.

### Rotas definidas

* POST: **/api/auth**

Essa rota provê o token necessário para o acesso. É necessário enviar no corpo da requisição HTTP um usuário (**username**) e senha (**password**) para a obtenção do token.

* GET **/api/teste**

Essa é uma rota segura de teste. Ela retorna um JSON de sucesso caso tenha recebido um token válido no corpo da requisição. O token pode ser enviado como parâmetro da URL, no corpo da requisição ou através do cabeçalho '*x-access-token*'

