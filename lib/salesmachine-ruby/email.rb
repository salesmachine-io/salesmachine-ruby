module SalesMachine

  class Email
    def self.send(contact_uid, email_name, data={})
      message = { :contact_uid => contact_uid.to_s, :email_name => email_name, :params => data }
      publisher = Publisher.new()
      return  publisher.post(:email, message)
    end
  end
end
