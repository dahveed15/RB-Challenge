require 'json'

#Terminal information

#install ruby => brew install ruby
#run the ruby script => ruby lib/challenge.rb *file1* file2*
#for example, ruby lib/challenge.rb cart-4560.json base-prices.json

#run tests => bundle exec rspec

def calculate_cart_total

  if ARGV.empty?
    return "You must provide a cart file and base price file as command line arguments\n"
  end

  #get command line arguments
  cart_obj = convert_file_into_object(ARGV[0])
  base_price_obj = convert_file_into_object(ARGV[1])

  total = 0

  cart_obj.each do |obj|
    if find_base_price(obj, base_price_obj)
      base_price = find_base_price(obj, base_price_obj)
      total += (base_price + (base_price * (obj["artist-markup"] / 100.0)).floor) * obj["quantity"]
    end
  end

  total.to_s + "\n"
end

def convert_file_into_object(file)
  #give me all the information in the JSON files as an object for each file
  JSON.parse(File.read(file))
end

#This method passes in one of the objects in the cart file and finds the base price for it in the base prices file
def find_base_price(obj, arr)

  price = nil
  count = 0

  filtered_objs = []

  arr.each do |obj2|
    if obj["product-type"] == obj2["product-type"]
      filtered_objs.push(obj2)
    end
  end

  #go through the options of each obj in the base price file and grab the one
  #that satisfies all of the options in the current cart file object
  filtered_objs.each do |obj2|
    obj2["options"].each_key do |k|
      if obj2["options"][k].include?(obj["options"][k])
        count += 1
      end
    end
    if count == obj2["options"].length
      price = obj2["base-price"]
      break
    else
      count = 0
    end
  end

  price
end


print calculate_cart_total
