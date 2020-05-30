module UsersHelper
    def profile_image(user, size=80)
        puts user
        puts size
        url = "https://secure.gravatar.com/avatar/#{user.gravatar_id}?s=#{size}"
        image_tag(url, alt: user.name)
    end
end
