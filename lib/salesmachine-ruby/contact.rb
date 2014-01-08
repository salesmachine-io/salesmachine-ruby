module SalesMachine

	class Contact
		def self.set(unique_id,data={})
			publisher=Publisher.new()
			message = {:unique_id=>unique_id.to_s,:params=>data}

			return publisher.post(:contact,message)

		end
	end
end
