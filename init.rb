I18n.load_path << File.dirname(__FILE__) + '/lib/semantic_attributes/locale/en.yml'
require 'semantic_attributes/railtie'

SemanticAttributes::Railtie.insert
