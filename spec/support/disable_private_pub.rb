# Disables Private Pub for tests. Useful for testing when you are using a DB
# driver that does not allow multiple connection per threads (i.e. PostgreSQL)
module PrivatePub
  class << self
    def publish_to(channel, data)
    end
  end
end
