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

	describe '#authenticate_with_token' do
		controller do
			before_action :authenticate_with_token!
			def restricted_action;end#método de apenas uma linha
		end

		context 'when there is no user logged in' do
			before do
				allow(app_controller).to receive(:current_user).and_return(nil)
				routes.draw { get 'restricted_action' => 'anonymous#restricted_action' }
				get :restricted_action
			end

			it 'returns status code 401' do
				expect(response).to have_http_status(401)
			end

			it 'returns json data for errors' do
				expect(json_body).to have_key(:errors)
			end
		end
	end

	describe '#user_logged_in?' do
		context 'when there is user logged in' do
			before do
				user = create(:user)
				allow(app_controller).to receive(:current_user).and_return(user)
			end

			it { expect(app_controller.user_logged_in?).to be true }
		end

		context 'when there is not user logged in' do
			before do
				allow(app_controller).to receive(:current_user).and_return(nil)
			end

			it { expect(app_controller.user_logged_in?).to be false }
		end
	end

end