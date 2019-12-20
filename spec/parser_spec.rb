require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is from website' do
    let(:email){ 
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org'],
      email.subject = 'Foo',
      email.raw_html = "<!doctype html>\r\n<html xmlns=\"http://www.w3.org/1999/xhtml\" dir=\"ltr\" lang=\"pt-BR\">\r\n<head>\r\n<title>Formulario de contato enviado por Chery Wei Motors Lapa</title>\r\n</head>\r\n<body>\r\n<p>Responder para: Marcio <marcioklepacz@gmail.com><br />\r\nAssunto: Quero saber sobre o novo Tiggo</p>\r\n<p>Corpo da mensagem:<br />\r\nQuero trocar o meu i30</p>\r\n<p>--<br />\r\nFormulario de contato enviado por Chery Wei Motors (http://weimotors.com.br)</p>\r\n</body>\r\n</html>\r\n\r\n\r\n"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Marcio')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('marcioklepacz@gmail.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq("Quero trocar o meu i30\r")
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq('Quero saber sobre o novo Tiggo')
    end
    
  end
end
