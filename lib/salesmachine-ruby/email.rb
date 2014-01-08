module SalesMachine

	class Email
		def self.send(unique_id,email_name,data={})
			message = {  :unique_id=>unique_id.to_s,:email_name=>email_name,:params=>data}
			publisher=Publisher.new()
			return 	publisher.post(:email, message)
		end
	end
end
