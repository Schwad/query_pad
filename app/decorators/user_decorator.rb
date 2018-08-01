class UserDecorator < ApplicationDecorator
  delegate_all

  def flair
    return '' if score < 26
    return content_tag(:span, '-power user-', class: "badge badge-primary") if power_user
    return content_tag(:span, '-moderator-', class: "badge badge-success") if moderator_user
  end

end
