ROOT_DIR = File.join(File.dirname(__FILE__), '..', '..')
FEATURES_DIR = File.join(ROOT_DIR, 'features', 'gherkin')
SUPPORT_DIR = File.join(ROOT_DIR, 'features', 'support')
$LOAD_PATH.unshift(ROOT_DIR, SUPPORT_DIR, FEATURES_DIR)

require 'env'
require 'cuke_sniffer_extension'

World(CukeSnifferExtension)