module SalesMachine

	class Email
		def self.send(email_uid, email_name, data={})
			message = { :email_uid => email_uid.to_s, :email_name => email_name, :params => data }
			publisher = Publisher.new()
			return 	publisher.post(:email, message)
		end
	end
end
