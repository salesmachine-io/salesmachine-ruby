module SalesMachine
	# Alias of USER will be deprecated
	class Contact
		def self.set(unique_id,data={})
			publisher=Publisher.new()
			message = {:unique_id=>unique_id.to_s,:params=>data}

			return publisher.post(:user,message)

		end
	end
end
