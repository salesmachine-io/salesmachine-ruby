module SalesMachine

  class User
    def self.set(contact_uid, data={})
      publisher = Publisher.new()
      message = { :contact_uid => contact_uid.to_s, :params => data }
      return publisher.post(:contact, message)
    end
  end
end
