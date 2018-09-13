require 'challenge'

describe "Redbubble Challenge" do

  it 'ensures input with no command line arguments will not output a total' do
    if ARGV.empty?
      expect(calculate_cart_total).to eq("You must provide a cart file and base price file as command line arguments\n")
    end
  end

  it 'returns string representations of the cart total with a newline character' do
    ARGV[0] = 'cart-9363.json'
    ARGV[1] = 'base-prices.json'

    expect(calculate_cart_total).to eq("9363\n")
  end

  it 'finds a base price for an object in the cart file' do
    cart_obj = convert_file_into_object('cart-9363.json')
    base_price_obj = convert_file_into_object('base-prices.json')

    expect(find_base_price(cart_obj[0], base_price_obj)).to eq(3800)
  end

  it 'ensures base price is nil if none of the base price file objects match a cart file object' do
    base_price_file = File.read('base-prices.json')
    base_price_obj = JSON.parse base_price_file

    expect(find_base_price({ "product-type" => "david", "options" => { "size" => "small", "colour" => "white", "print-location" => "front" }, "artist-markup" => 20, "quantity" => 1 }, base_price_obj)). to be_nil
  end

  it 'ensures that JSON files get parsed into usable array objects' do
    expect(convert_file_into_object('cart-9363.json')).to be_instance_of Array
  end


end
