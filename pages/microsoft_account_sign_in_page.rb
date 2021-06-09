class MicrosoftAccountSignInPage < TMAPage

  text_field(:sign_in, id: 'i0116')

  def self.page_title_validation_value
    /Sign/
  end

  def self.page_url_validation_value
    /login/
  end

  def form_field_order
    %w[
        sign_in
    ]
  end

end