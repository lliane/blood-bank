require 'minitest/autorun'
require 'json-schema'
require 'json'

SCHEMA_FILE = File.join(File.dirname(File.expand_path(__FILE__)) , 'schema', 'about_us.json')
ABOUTUS_PATH = File.join(File.dirname(File.expand_path(__FILE__)) , 'about_us')
schema = File.open(SCHEMA_FILE) { |f| JSON.parse(f.read) }

describe 'aboutus' do
  Dir["#{ABOUTUS_PATH}/*\.*"].each do |file|
    it "#{file.sub(/(\..*$)/,'').sub(/^#{ABOUTUS_PATH}/,'')} contains valid json" do
      
      
      begin
        json_str = File.open(file) { |f| f.read }
        # force_encoding only available in ruby 1.9.2
        aboutus = JSON.parse( json_str.respond_to?(:force_encoding ) ? json_str.force_encoding('UTF-8') : json_str)['aboutus']
        JSON::Validator.validate!(schema, aboutus, :version=> :draft3 )
      rescue JSON::Schema::ValidationError => schema_error
         assertion = false, schema_error.message + "\nIn: #{file}\n[#{aboutus['created_by']}, please fix this and send another pull request!]"
      rescue JSON::ParserError => parser_error
         assertion = false, parser_error.message
      else
         assertion = true
      end

      assert *assertion
    end
  end
end

