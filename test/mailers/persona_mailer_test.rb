require 'test_helper'

class PersonaMailerTest < ActionMailer::TestCase
  test "recibo" do
    mail = PersonaMailer.recibo
    assert_equal "Recibo", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
