# Iter 1-2
class ContactBatchMailer < ActionMailer::Base
  default from: 'yuhongzhan0407@berkeley.edu'
  # default from: 'yo@example.com'
  
  #Iter 2-2
  def contact_batch_email(name, message, subject, recipient, send)
    if (send == "on")
      @list = Attachment.get_files
      @list.each do |name|
        if name.end_with?(".txt")
          attachments[name] = File.read(Rails.root.join("app/assets/attachment/#{name}"))
        else
          attachments.inline[name] = File.read(Rails.root.join("app/assets/attachment/#{name}"))
        end
      end
    end
    mail(to: recipient, name: name, subject: subject, body: message)
  end
  #End of Iter 2-2

end
# End for Iter 1-2