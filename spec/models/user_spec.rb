require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) { build(:user) } #cuja chamada para o teste passa a ser

	#it { expect(user).to respond_to(:email) } #sem o @

	#context 'when name is blank' do
	#	before { user.name = " " }

	#	it { expect(user).not_to be_valid } 
	#end

	#context 'when name is nil' do
	#	before { user.name = nil }

	#	it { expect(user).not_to be_valid } 
	#end

	#Usando o Shoulda-matchers
	#it { expect(user).to validate_presence_of(:name) }
	#É mais comum a seguinte abordagem:
	it { is_expected.to validate_presence_of(:email) }
	it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
	it { is_expected.to validate_confirmation_of(:password) }
	it { is_expected.to allow_value("Ale@ale.com").for(:email) }

	#subject{ FactoryGirl.build(:user) }, mas devido à configuração feita no rails_helper em spec para
	#o factorygirl, podemos usar apenas:
	#subject{ build(:user) }

  	#before { @user = FactoryGirl.build(:user) }

  	#Essa não é a melhor maneira de escrever os testes:
  	#it { expect(@user).to respond_to(:email) }
  	#it { expect(@user).to respond_to(:name) }
  	#it { expect(@user).to respond_to(:password) }
  	#it { expect(@user).to respond_to(:password_confirmation) }
  	#it { expect(@user).to be_valid }

  	#Usando o subject (melhor prática):
  	#it { expect(subject).to respond_to(:email) }
  	#it { expect(subject).to be_valid }

  	#Testar comportamento de uma instância da classe user (as 3 formas são equivalentes):
  	#it { expect(@user).to respond_to(:email) }
  	#it { expect(subject).to respond_to(:email) }
  	#it { is_expected.to respond_to(:email) }

end
