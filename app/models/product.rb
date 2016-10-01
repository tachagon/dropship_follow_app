class Product < ApplicationRecord
	belongs_to :superproduct, class_name: "Product", optional: true
	has_many :subproducts, class_name: "Product", foreign_key: "superproduct_id", dependent: :destroy

	def show_status
	  if self.status == "in_stock"
	  	return "<span style='color: green;'>In Stock</span>"
		elsif self.status == "out_stock"
			return "<span style='color: red;'>Out Stock</span>"
		elsif self.status == "superproduct"
			return "<span style='color: orange;'>Super Product</span>"
	  else
	  	return "<span style='color: gray;'>Not Found</span>"
	  end
	end

	scope :single_and_superproduct, -> { where(superproduct: nil)   }

end
