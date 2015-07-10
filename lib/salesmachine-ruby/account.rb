module SalesMachine

	class Account
		def self.set(account_uid, data={})
			publisher = Publisher.new()
			message = { :account_uid => account_uid.to_s, :params => data }
			return publisher.post(:account, message)
		end
	end
end
