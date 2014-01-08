module SalesMachine

	class User
		def self.set(unique_id,data={})
			publisher=Publisher.new()
			message = {:unique_id=>unique_id.to_s,:params=>data}

			return publisher.post(:user,message)

		end
	end
end
