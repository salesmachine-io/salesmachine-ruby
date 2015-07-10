module SalesMachine

  class Track
    def self.event(contact_uid, event_uid, data={})
      publisher = Publisher.new()
      data[:display_name] = data[:display_name] || event_uid
      return publisher.track(contact_uid.to_s, event_uid, data)
    end

    def self.pageview(contact_uid, data={})
      return self.event(contact_uid.to_s, :pageview, data)
    end

    def self.email(contact_uid, email_name, data={})
      publisher = Publisher.new()
      data[:display_name] = email_name
      return publisher.track(contact_uid.to_s, :email, data)
    end
  end
end
