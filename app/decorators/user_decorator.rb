class UserDecorator < Draper::Decorator
  delegate_all

  def full_name_or_email
    if first_name.present?
      "#{first_name} #{last_name}".strip
    else
      "#{email}"
    end
  end
end
