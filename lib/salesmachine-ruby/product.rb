module SalesMachine

	class Product
		def self.set(unique_id,data={})
			publisher=Publisher.new()
			message = {:unique_id=>unique_id.to_s,:params=>data}
			return publisher.post(:product,message)
		end
	end
end
