class UserDecorator < ApplicationDecorator
  delegate_all

  def flair
    return '' if score < 26
    return content_tag(:u, ' -power user-') if power_user
    return content_tag(:u, ' -moderator-') if moderator
  end

end
