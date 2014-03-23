class ContactMailer < ActionMailer::Base
  default to: "janko.marohnic@gmail.com",
          cc: "matija.marohnic@gmail.com"

  def contact(params)
    sender, message = params[:sender], params[:message].to_s

    mail(
      reply_to: sender,
      subject: message.truncate(30),
      body: message,
    )
  end
end
