require 'dry/system/container'

module SmarthomeApi
  class Container < Dry::System::Container
    configure do |config|
      config.name = :smarthome_api
      config.root = File.expand_path('../', __dir__).freeze
      config.system_dir = config.root / 'config' / 'system'
      config.auto_register = %w[app/transactions app/validations]
    end

    load_paths! 'app', 'lib'
  end

  Import = Container.injector
end
Dry::Validation.load_extensions(:monads)

SmarthomeApi::Container.finalize!