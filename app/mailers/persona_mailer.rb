class PersonaMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.persona_mailer.recibo.subject
  #

  def recibo(persona)
    @greeting = ''
    @persona = persona
    recibo = PersonaPdf.new(@persona, 0)
    attachments["Recibo_#{@persona.cedula}_#{$ahora}.pdf"] = { mime_type: 'application/pdf', content: recibo.render }

    mail to: persona.correo, subject: "FUNSONE: Recibo de pago de nómina - #{$ahora}"
  end
end
