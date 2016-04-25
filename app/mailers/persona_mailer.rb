class PersonaMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.persona_mailer.recibo.subject
  #
  def recibo(persona)
    @greeting = "Hi"
@persona=persona
recibo = PersonaPdf.new(@persona)
attachments["recibo.pdf"] = { :mime_type => 'application/pdf', :content => recibo.render }

    mail to: persona.correo, subject: "Recibo de pago"
  end
end
