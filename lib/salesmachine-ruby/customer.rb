module SalesMachine

	class Customer
		def self.set(unique_id,data={})
			publisher=Publisher.new()
			message = {:unique_id=>unique_id.to_s,:params=>data}
			return publisher.post(:customer,message)
		end
	end
end
