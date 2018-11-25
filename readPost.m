%Function that takes a vector of html pages string as input and return a vertor of
% posting html pages that contain the info of each pages 

function  posthtml = readPost(html)

url_matrix = strings(20,length(html));
    %loopping through the html pages 
    for i = 1:length(html)
       %patterns of the html tages that store the posting url
       pattern1 = '<div class="title">';
       pattern2 = '<div>';
       current_list = extractBetween(html(i),pattern1,pattern2);
       pattern3 = '<a href="';
       pattern4 = '" class="title enable-search-navigation-flag "';
       
       %posting url list
       current_url_list = extractBetween(current_list,pattern3,pattern4);
       for j = 1:20
           current_url = current_url_list(j);
           current_full_url = strcat('https://www.kijiji.ca',current_url,'?siteLocale=en_CA');
           url_matrix(j,i) = current_full_url;
       end 
    end 

%reshape it to vector 
posturl = reshape(url_matrix,[],1);

posthtml = strings(1,length(posturl));
    for i = 1:length(posturl)
        current_url = posturl(i);
        posthtml(i) = string(webread(current_url));
    end

end