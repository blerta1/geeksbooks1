class User < ApplicationRecord
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..40},
                       :on => :create
  validates :password, :confirmation => true,
                       :length => {:within => 6..40},
                       :allow_blank => true,
                       :on => :update
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  has_secure_password
  after_destroy :ensure_an_admin_remains
  class Error  < StandardError
  end
 
  private
    def ensure_an_admin_remains
    	if User.count.zero?
    		raise Error.new "Can´t delete last user"
    	end
    end
 
end
