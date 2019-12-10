require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is from website' do
    let(:email){ 
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org'],
      email.subject = 'Foo',
      email.body = "\nResponder para: IVAN <zaniol2011@gmail.com>\n Assunto: Teste\nCorpo da mensagem: teste\n\n -- This e-mail was sent from a contact form on Chery Wei Motors (http://weimotors.com.br)"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('IVAN')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('zaniol2011@gmail.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('teste')
    end
  end
end
