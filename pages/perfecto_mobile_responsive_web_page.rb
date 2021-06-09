class PerfectoMobileResponsiveWebPage < TMAPage

  page_url("https://www.perfecto.io/blog/tips-responsive-web-design-testing")

  link(:responsive_web_testing_checklist, href: "http://docs.perfectomobile.com/docs/resources/responsive-web-testing-checklist-perfecto.pdf")


  def self.page_title_validation_value
    /perfecto/i
  end

  def self.page_url_validation_value
    /responsive/
  end

  def form_field_order
    %w[

    ]
  end
end
