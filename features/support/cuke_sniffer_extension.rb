module CukeSnifferExtension

  def customization_of_rules
    CukeSniffer::RuleConfig::RULES[:implementation_word][:enabled] = false
    CukeSniffer::RuleConfig::RULES[:implementation_word_button][:enabled] = false
    CukeSniffer::RuleConfig::RULES[:implementation_word_tab][:enabled] = false
    CukeSniffer::RuleConfig::RULES[:too_many_scenarios][:enabled] = false
    CukeSniffer::RuleConfig::RULES[:too_many_steps][:enabled] = false
    CukeSniffer::RuleConfig::RULES[:too_many_examples][:enabled] = false
    CukeSniffer::RuleConfig::RULES[:implementation_word][:words] = ['site', 'drop down', 'dropdown', 'select list', 'text box', 'xml', 'window', 'pop-up', 'screen', 'database']
    CukeSniffer::RuleConfig::RULES[:date_used][:enabled] = false
  end

  def execute_cuke_sniffer(directory = nil)
    @directory = directory
    if @directory.nil?
        @cuke_sniffer = CukeSniffer::CLI.new
      else
        @cuke_sniffer = CukeSniffer::CLI.new(features_location: "#{FEATURES_DIR}/#{directory}")
    end
  end

  def generate_cuke_sniffer_output
    dir = "#{output_folder}/#{Time.now.strftime('%Y-%m-%d')}"
    Dir.mkdir(dir) unless Dir.exists?(dir)
    @cuke_sniffer.output_html("#{dir}/cuke_sniffer_report.html")
  end

end

module CukeSniffer
  module RuleConfig

    custom_rules = {
        :invalid_tag => {
            :enabled => true,
            :phrase => 'Non-standard tag: {tag}',
            :score => WARNING,
            :tags => %w[@\d+app\d+ @testcaseid\d+ @pbi\d+ @defect\d+ @smoke_test @regression @manual @wip],
            :targets => %w[Scenario Feature],
            :reason => lambda do |scenario, rule|
              scenario.tags.each do |tags|
                unless scenario.is_comment?(tags)
                  new_phrase = rule.phrase.gsub(/{.*}/, tags)
                  scenario.store_rule(rule, new_phrase) unless rule.conditions[:tags].include?(tags.gsub(/\d+/, '\d+'))
                end
              end
            end}}

    RULES.merge!(custom_rules)
  end
end