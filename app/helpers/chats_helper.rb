module ChatsHelper
  def user_icon(profile, class_names = "size-10")
    return if profile.blank?

    content_tag :div, class: [class_names, "flex-shrink-0 rounded-full bg-blue-500 text-white flex items-center justify-center"] do
      profile.name.first
    end
  end

  def message_content(message, its_me)
    return if message.blank?

    class_names = its_me ? "bg-blue-500 text-white" : "bg-gray-200 text-gray-800"
    content_tag :div, class: ["p-3 rounded-lg", class_names] do
      content_tag :p, message.content, class: "text-sm"
    end
  end
end
