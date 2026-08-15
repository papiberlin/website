# Roda is a simple Rack-based framework with a flexible architecture based
# on the concept of a routing tree. Bridgetown uses it for its development
# server.
#
# Learn more at: https://www.bridgetownrb.com/docs/routes

class RodaApp < Roda
  plugin :bridgetown_server

  route do |r|
    r.bridgetown
  end
end
