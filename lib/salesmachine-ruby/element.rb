module SalesMachine

	class Element
		def self.set(unique_id,dataset,data={})
			publisher=Publisher.new()
			data[:dataset]=dataset.to_sym
			message = {:unique_id=>unique_id.to_s,:params=>data}
			return publisher.post(:element,message)
		end
	end
end
