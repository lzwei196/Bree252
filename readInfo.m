%function that takes a vector of post html as info and return a table
%of attribues of the all posts, containing listing title, price, 
%number of bathroom and bedroom, address

function attributes = readInfo(posthtml)

%initialize the attribute vectors to store listing info
title = strings(1, length(posthtml));
price = zeros(1,length(posthtml));
num_bedroom = zeros(1,length(posthtml));
num_bathroom = zeros(1,length(posthtml));
address = strings(1,length(posthtml));

    %loop through all html pages
    for i = 1:length(posthtml)
  
    %find title 
    pattern_title1 = '<h1 class="title-2323565163">';
    pattern_title2 = '</h1>';
    
    %try and catch the error
    try
    current_title = extractBetween(posthtml(i),pattern_title1,pattern_title2);
    title(i) = current_title;
    catch
    warning('Title Not Found!');
    end


    %find price
    pattern_price1 = '<span class="currentPrice-441857624">';
    pattern_price2 = '</span>';
    current_listprice = string(extractBetween(posthtml(i),pattern_price1,pattern_price2));
    disp(current_listprice);
    pattern_price3 = '<span content="';
    pattern_price4 = '">';
    
    %try and catch the error
    try
    current_price = extractBetween(current_listprice,pattern_price3,pattern_price4);
    price(i)= current_price;
    catch
    warning('Price not found!');
    end
    
    
    
    %find number of bed room and bath room
    pattern_attribute1 = '<dd class="attributeValue-2574930263">';
    pattern_attribute2 = '</dd>';
    
    %try and catch the error
    try
    attribute = extractBetween(posthtml(i),pattern_attribute1,pattern_attribute2);
    %bathroom
    bathroom = attribute(1);
    current_num_bathroom = strtok(bathroom);
    num_bathroom(i) = current_num_bathroom;
    %bedroom
    bedroom = attribute(2);
    current_num_bedroom = strtok(bedroom);
    num_bedroom(i) = current_num_bedroom;
    catch
    warning("Attribute not found!");
    end
    
    %find address
    pattern_address1 = 'class="address-3617944557">';
    pattern_address2 = '</span>';

    try
    
    current_address = extractBetween(posthtml(i),pattern_address1,pattern_address2);
    address(i) = current_address;

    catch
    warning("Address not found!");   
    end 
    end 
    
attributes  = table(transpose(title),transpose(price),transpose(num_bedroom),transpose(num_bathroom),transpose(address));
attributes.Properties.VariableNames = ["title","price","num_bedroom","num_bathroom","address"];

end 
