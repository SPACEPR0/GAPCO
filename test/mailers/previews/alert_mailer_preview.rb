# Preview all emails at http://localhost:3000/rails/mailers/alert_mailer
class AlertMailerPreview < ActionMailer::Preview
    def alert_email_preview
        AlertMailer.alert_email(User.first, Alert.first)
    end
end
