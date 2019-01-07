require 'api_version_constraint'

Rails.application.routes.draw do

  devise_for :users
  	namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: "/" do
  		namespace :v1, path: "/", constraints: ApiVersionConstraint.new(version: 1, default: true) do
  			resources :users, only: [:show]
  		end
	end
end

#Definindo o :api ganho o path www.site.com/api, podendo ter, por exemplo, o url (path) 
#www.site.com/api/tasks, que buscaria o controller tasks dentro da namespace api.

#Defaults: { format: :json } especifica o formato que a requisição retornará à url.

#Constraints: especificar restrições! Nesse caso, tanto para o exemplo quanto para o projeto,
# é necessário haver um domínio api para entrar no controller dentro de api. 
#A url www.site.com/api/tasks não teria premissão para acessar o controller tasks. 
#O acesso seria garantido se a url fosse api.site.com/api/tasks.

#Mas os dois api's na url não estão corretos. Então, para ajustar isso, passamos o comando
#path para renomear a namespace. Na prática, caso o comando fosse path: "xana", a url deixaria
# de ser api.site.com/api/tasks e seria api.site.com/xana/tasks.
#Ao passar o path: "/", eu digo pro rails usar um path relativo ao domínio original; ou seja,
#eu removo a necessidade do resource api na url, tendo como resultado para o exemplo
#api.site.com/tasks, em que eu acessaria o controller tasks normalmente.
