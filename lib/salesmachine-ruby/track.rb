module SalesMachine

	class Track
		def self.pageview(unique_id,data={})
			publisher=Publisher.new()
			return publisher.track(:pageview,unique_id.to_s,data)
		end

		def self.email(unique_id,title,data={})
			publisher=Publisher.new()
			data[:title]=title
			return publisher.track(:email,unique_id.to_s,data)
		end

		def self.event(unique_id,title,data={})
			publisher=Publisher.new()
			data[:title]=title
			return publisher.track(:event,unique_id.to_s,data)
		end


		def self.revenue(unique_id,title,data={})
			publisher=Publisher.new()
			data[:title]=title
			return publisher.track(:revenue,unique_id.to_s,data)
		end


		def self.custom(unique_id,event,title,data={})
			publisher=Publisher.new()
			data[:title]=title
			return publisher.track(event,unique_id.to_s,data)
		end
	end
end
