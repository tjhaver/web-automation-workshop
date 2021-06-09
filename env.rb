LIB_DIR = File.join(ROOT_DIR, 'lib')
PAGES_DIR = File.join(ROOT_DIR, 'pages')
DATA_DIR = File.join(LIB_DIR, 'data')
DATA_SOURCE_DIR = File.join(DATA_DIR, 'data_source')
HELPERS_DIR = File.join(LIB_DIR, 'helpers')
$LOAD_PATH.unshift(LIB_DIR, DATA_DIR, HELPERS_DIR, PAGES_DIR, DATA_SOURCE_DIR)

require 'date'
require 'open-uri'
require 'openSSL'

require 'data_helper'
require 'web_helper'
require 'page_helper'

require 'page-object'
require 'watir'
require 'cuke_sniffer'
require 'certified'
require 'pdf-reader'

include(DataHelper, PageObject::PageFactory, WebHelper, PageHelper)

require 'tma'
require 'tma_data'
require 'tma_page'

PageObject.javascript_framework = :jquery

Dir["#{PAGES_DIR}**/*.rb"].each {|file| require file}

ENV['TIMESTAMP'] ||= Time.now.strftime '%Y-%m-%d_%H-%M-%S'