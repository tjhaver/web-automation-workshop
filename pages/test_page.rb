class TestPage < TMAPage

  page_url(environment_url)

  def self.page_title_validation_value
    /google/
  end

  def self.page_url_validation_value
    /google/
  end

end