require "weimotors/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_custom/hooks"
require "f1sales_helpers"

module Weimotors
  class Error < StandardError; end
  class F1SalesCustom::Email::Source 
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website'
        },
      ]
    end
  end
  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(Responder para|Assunto|Telefone|Corpo da mensagem).*?:/, false)

      name, email = parsed_email['responder_para'].split(' ')
      message = parsed_email['corpo_da_mensagem'].split(' ').first

      {
        source: {
          name: F1SalesCustom::Email::Source.all[0][:name],
        },
        customer: {
          name: name,
          phone: '',
          email: email.gsub('<','').gsub('>',''),
        },
        product: '',
        message: message
      }
    end
  end
end
