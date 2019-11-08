class PasswordMailer < ApplicationMailer
    default from "verificacionccuson@gmail.com"

    def password_email(:email)
        @User = User.find(params[:email])
        @User.reset_password.('contrasenia', 'contrasenia')
        @User.send_reset_password_instructions
        mail(to:@User.email, subject: "Recuperar contraseña")
    end
end
