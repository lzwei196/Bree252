%Function that take district and number of page as input and return a vertor of
%all kijiji pages with appartment posting
%https://www.kijiji.ca/b-appartement-condo/ville-de-montreal/c37l1700281

function html = readHTML(district, numPage)

%base url
base_url = "https://www.kijiji.ca/";
%apartment 
apartment = "b-appartement-condo/";
%search code
code = "/c37l1700281";

%pattern for pages 
page = strings(1,numPage);
    for i = 1:numPage
        if i == 1 
            page(i) = "";
        else 
            page(i) = strcat("/page-",string(i));
        end
    end
disp(page);
%concatenate sting to find all urls and read to html
html = strings(1,numPage);
    for i = 1:numPage
        current_url = strcat(base_url,apartment,district,page(i),code);
        html(i) = string(webread(current_url));
    end
end