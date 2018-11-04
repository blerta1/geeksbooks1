class Product < ApplicationRecord
	attr_accessor :image
	belongs_to :category
	validates_presence_of :category
	has_many :line_items
	has_many :orders, through: :line_items
	before_destroy :ensure_not_referenced_by_any_line_item
	mount_uploader :image, ImageUploader
	mount_uploader :pdf, PdfUploader
	validates :title, :description,:image,  presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.00}
	validates :title , uniqueness: true
	validates :image , allow_blank:true ,format: {
		with: %r{\.(gif|jpg|png)\Z}i,
		message: 'must be a URL for GIF, JPG or PNG image.'
	}
	validates :pdf , allow_blank:true ,format: {
		with: %r{\.(pdf|jpg|png)\Z}i,
		message: 'must be a URL for PDF file'
	}
	private
	#ensure there are no line itmes referencing this product
	
	def ensure_not_referenced_by_any_line_item
		unless line_items.empty?
			errors.add(:base, 'Line Items Present')
		    throw :abort
		end
	
	end 
	def self.keyword_search(keywords)
		keywords = "%" + keywords + "%"
		Product.where("title LIKE ? OR description LIKE ?", keywords, keywords)
    end 
    
end
