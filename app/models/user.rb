class User
	attr_accessor :token, :name, :email, :trade_credit, :points
	def initialize(token, email, name, trade_credit, points, record_digest)
		@email = email
		@token = token
      @name = name
      @trade_credit = trade_credit
      @points = points
      @record_digest = record_digest
	end
end
