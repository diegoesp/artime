# Not persistent class that holds role codes
class Role

  DEVELOPER = 10
  MANAGER = 20
  COMPANY = 30
  GOD = 40

 	def self.role_codes
 		[DEVELOPER, MANAGER, COMPANY, GOD]
 	end

end