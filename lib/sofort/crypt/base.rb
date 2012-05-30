require 'digest/sha2'

module Sofort

  module Encryptors

    class Base
  
      class << self
  
        def digest(values_holder={})
          encryptor = Digest.const_get(Sofort.encryptor.upcase)
          return encryptor.hexdigest(values_holder.send(:sofort_string))
        end
  
        def valid?(digest,values_holder={})
          self.digest(values_holder).eql?(digest)
        end
  
      end
    end

  end

end