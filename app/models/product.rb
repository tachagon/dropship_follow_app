class Product < ApplicationRecord
	belongs_to :superproduct, class_name: "Product", optional: true
	has_many :subproducts, class_name: "Product", foreign_key: "superproduct_id", dependent: :destroy

	scope :single_and_superproduct, -> { where(superproduct: nil)   }

end
