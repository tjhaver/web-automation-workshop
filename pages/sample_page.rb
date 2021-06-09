class SamplePage < TMAPage

  page_url(environment_url)

  div(:login_widget, :id => 'login-popover')
  div(:logo, :id => 'fake')
  text_field(:ask_search, :id => 'searchInputHeader')
  text_field(:personal_username, :id => 'personal-username')
  text_field(:personal_password, :id => 'personal-password')
  button(:personal_log_in, :class => 'button--white', :index => 0)
  div(:username_error_message_popup, :class => 'errors', :index => 0)
  div(:password_error_message_popup, :class => 'errors', :index => 1)
  link(:personal_forgot_username, :text => 'Forgot Username?', :index => 0)
  link(:personal_forgot_password, :text => 'Forgot Password?', :index => 0)

  def form_field_order
    %w{
        personal_username
        personal_password
    }
  end

  def self.page_title_validation_value
    /sample/
  end

  def self.page_url_validation_value
    /sample/
  end

end