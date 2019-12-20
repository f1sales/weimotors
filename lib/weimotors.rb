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
          email_id: 'redirecionaf1',
          name: 'Website'
        },
      ]
    end
  end
  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = ("\n" + remove_html_tags(@email.raw_html)).colons_to_hash(/(Responder para|Assunto|Telefone|Corpo da mensagem).*?:/, false)

      email = "marcio@gest.com" # @email.raw_html[/para:(.*?)br/][/<(.*?)>/].gsub('>', '').gsub('<', '') 

      name = parsed_email['responder_para']
      message = parsed_email['corpo_da_mensagem'].split("\n").first

      {
        source: {
          name: F1SalesCustom::Email::Source.all[0][:name],
        },
        customer: {
          name: name,
          phone: '',
          email: email,
        },
        product: '',
        message: message,
        description: parsed_email['assunto']
      }
    end

    private

    def remove_html_tags(text)
      re = /<("[^"]*"|'[^']*'|[^'">])*>/
      text.gsub(re, '')
    end
  end
end
