class User
  include Mongoid::Document

  sofort

  field :email, :type => String, :default => "hans@web.de"

  def holder
    "Hans Meiser"
  end
end