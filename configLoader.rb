require 'yaml'

module ConfigLoader
  class LoadConfig
    def load
      configMap = {}
      begin
        configMap = YAML::load(File.open('config/config.yaml'))
        puts configMap
      rescue Exception => e
        configMap[:error] = e.message
      end
      return configMap
    end
  end
end
