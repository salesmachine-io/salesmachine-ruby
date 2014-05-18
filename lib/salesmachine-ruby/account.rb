module SalesMachine

	class Account
		def self.set(unique_id,data={})
			publisher=Publisher.new()
			message = {:unique_id=>unique_id.to_s,:params=>data}
			return publisher.post(:account,message)
		end
	end
end
