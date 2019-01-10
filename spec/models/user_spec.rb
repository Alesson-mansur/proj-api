require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) { build(:user) } #cuja chamada para o teste passa a ser
	#it { expect(user).to respond_to(:email) } #sem o @, mas vamos passar a usar o Shoulda-matchers

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
	it { is_expected.to allow_value('Ale@ale.com').for(:email) }
	it { is_expected.to validate_uniqueness_of(:auth_token) }

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

  	describe '#info' do #testar um método de instância
  		it 'returns email and created_at' do
  			user.save! #O ! nesse caso faz com que o active-record execute uma excessão
  			#que para o teste caso o objeto não seja salvo. Sem o ! seria retornado apenas
  			#um false caso o objeto não fosse salvo.
  			allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')

  			expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: abc123xyzTOKEN")
  		end
  	end

  	describe '#generate_authentication_token!' do

  		it 'generates a unique auth token' do
  			allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')
  			user.generate_authentication_token!

  			expect(user.auth_token).to eq('abc123xyzTOKEN')
  		end

  		it 'generates another auth token when the current auth token already has been taken' do
  			allow(Devise).to receive(:friendly_token).and_return('abc123tokenxyz', 'abc123tokenxyz','abcXYZ123456789')
  			existing_user = create(:user)
  			user.generate_authentication_token!

			expect(user.auth_token).not_to eq(existing_user.auth_token)		
  		end

  	end

end
