module UsersHelper
	def gravatar_for(user,options ={size: 80})
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		# image_tag(gravatar_url,alt:user.name,class: "gravatar")
		if user.icon?
			image_tag((user.icon),size: "#{size}x#{size}",alt:user.name,class: "gravatar")
		else
			image_tag("rails.png",size: "#{size}x#{size}",alt:user.name,class: "gravatar")
		end
		
	end
end
