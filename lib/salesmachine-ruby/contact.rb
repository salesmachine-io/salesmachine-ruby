module SalesMachine

	# Alias of USER will be deprecated
	class Contact
		def self.set(contact_uid, data={})
			User.set(contact_uid, data)
		end
	end
end
