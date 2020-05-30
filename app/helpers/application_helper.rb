module ApplicationHelper

def nav_link_to(text, url)
    if current_page?(url)
        link_to(text, url, class: "active")
    else
        link_to(text, url)
    end
end

end
