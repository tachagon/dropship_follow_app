class ProductsController < ApplicationController
	def index
		@product = Product.new
		@products = Product.single_and_superproduct
	end

	def show
		@product = Product.find(params[:id])
	end

	def create
		url = params[:product][:url]
		url = URI.escape(params[:product][:url]) unless url.ascii_only?
		begin
			unless dup_product?(url)
				page = Nokogiri::HTML(open(url))

				# check a product or many subproduct
				# and send each product to add a product
				if page.css(".subproductItem").any?
					# have subproduct
					superproduct = new_superproduct(page, url)
					superproduct.save!

					subproducts = page.css(".subproductItem").to_a
					subproducts.each { |product|
						subproduct = new_product(product, url)
						subproduct.superproduct = superproduct
						subproduct.save!
					}
					flash[:success] = "Add a superproduct and subproduct success."
					redirect_to superproduct and return
				else
					# not have subproduct
					product = new_product(page, url)
					product.save!
					flash[:success] = "Add a new product success."
					redirect_to product and return
				end

			else
				# user try add duplidate product
				flash[:danger] = "This product has already"
				redirect_to root_path and return
			end

		rescue OpenURI::HTTPError => ex
			flash[:danger] = "Something wrong, #{ex}"
			redirect_to root_path and return
		end
	end

	def sync_products

	end

	def sync_product

	end

	def search

	end

	private

		# check duplicate product from url
		def dup_product?(url)
		  product = Product.find_by_url(url)
			return product != nil ? true : false
		end

		# return a new product
		def new_product(page, url)
			product = Product.new(
				code: get_product_code(page),
				name: get_product_name(page),
				status: get_product_status(page),
				description: get_product_description(page),
				cost_price: get_product_cost_price(page),
				url: url,
				last_sync: Time.now,
				image: get_product_image(page)
			)
			return product
		end

		def new_superproduct(page, url)
			product = Product.new(
				code: get_product_code(page),
				name: get_product_name(page),
				status: "superproduct",
				description: get_product_description(page),
				cost_price: 0.0,
				url: url,
				last_sync: Time.now,
				image: get_product_image(page)
			)
			return product
		end

		def get_product_code(page)
			code = page.css(".productDataBlock .codeTR .bodyTD").text | page.css(".codeTR .bodyTD").text
		  return code | "Not have code"
		end

		def get_product_name(page)
		  name = page.css(".productHeaderBlock .headerText").text
			name = name | page.css(".subproductHeader .headerText").text
			return name
		end

		def get_product_status(page)
		  if page.css(".typeTR").any?
		  	return "in_stock" if page.css(".typeTR .bodyTD").text == "พร้อมส่ง"
		  elsif page.css(".product_soldout").any? or page.css(".subproduct_soldout").any?
		  	return "out_stock"
		  end
			return "not_found"
		end

		def get_product_description(page)
			return page.css("#detail").to_html
		end

		def get_product_cost_price(page)
		  cost_price = page.css(".priceTR .bodyTD").text
			return cost_price.split(" ")[0].to_f
		end

		def get_product_image(page)
		  image = page.css(".productPhoto .productImage")
			image = image | page.css(".subproductImage")
			return image.attr("src").to_s
		end

end
