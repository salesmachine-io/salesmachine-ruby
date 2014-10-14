module SalesMachine

	class Track
		def self.event(unique_id,event_id,data={})
			publisher=Publisher.new()
			return publisher.track(event_id,unique_id.to_s,data)
		end

		def self.pageview(unique_id,data={})
			return self.event(unique_id.to_s,:pageview,data)
		end

		def self.email(unique_id,title,data={})
			publisher=Publisher.new()
			data[:title]=title
			return publisher.track(:email,unique_id.to_s,data)
		end

		def self.order(unique_id,title,data={})
			publisher=Publisher.new()
			data[:title]=title
			return publisher.track(:order,unique_id.to_s,data)
		end

		# will be deprecated use event instead
		def self.custom(unique_id,event_id,title,data={})
			data[:title]=title
			return self.event(unique_id,event_id,data)
		end
	end
end
