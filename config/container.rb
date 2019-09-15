require 'dry/system/container'

module SmarthomeApi
  class Container < Dry::System::Container
    configure do |config|
      config.name = :smarthome_api
      config.root = File.expand_path('../', __dir__).freeze
      config.system_dir = config.root / 'config' / 'system'
      config.auto_register = %w[lib app/transactions]
    end

    load_paths! 'app', 'lib'
  end

  Import = Container.injector
end

SmarthomeApi.finalize!

SmarthomeApi.require_from_root(
  'app/validations/**/*.rb'
)
