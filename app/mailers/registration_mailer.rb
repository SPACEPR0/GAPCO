class RegistrationMailer < ApplicationMailer
    default from: "verificacionccuson@gmail.com"
    def registration_email(user, generated_password)
        @user = user
        @generated_password = generated_password
        mail(to: @user.email, subject: 'Bienvenido a GAPCO')
    end
end
