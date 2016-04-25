# Preview all emails at http://localhost:3000/rails/mailers/persona_mailer
class PersonaMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/persona_mailer/recibo
  def recibo
    PersonaMailer.recibo
  end

end
