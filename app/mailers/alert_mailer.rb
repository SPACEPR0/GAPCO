class AlertMailer < ApplicationMailer
    
    def self.send_alert(emails, alert)
        @emails = emails
        emails.each do |e|
            alert_email(e, alert).deliver_now
        end
    end
    def alert_email(email, alert)
        @alert = alert
        @email = email

        mail(to: email, subject: 'Nueva Alerta')
    end
end
