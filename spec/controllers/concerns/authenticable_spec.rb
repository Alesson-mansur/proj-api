require 'rails_helper'

RSpec.describe Authenticable do
	controller(ApplicationController) do
		include Authenticable
	end	#Com isso, o subject deixa de ser a instância da classe definida no Rspec.describe
	#e passa a ser o controller anônimo definido pelo controller(AppicationController),
	#que é herança do ApplicantionController.

	let(:app_controller) { subject }#Essa chamada cria um alias para o subject, fazendo
	#com que o método genérico subject.method passe a ser app_controller.method.

	describe '#current_user' do
		let(:user) { create(:user) }

		before do
			req = double(:headers => { 'Authorization' => user.auth_token })#cria um objeto
			#dublê que retornaria na chamada req.headers o auth_token do user criado no let
			allow(app_controller).to receive(:request).and_return(req)
		end

		it 'returns user from authorization header' do
			expect(app_controller.current_user).to eq(user)
		end
	end

end