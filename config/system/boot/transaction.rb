Reviews::Container.boot(:transaction) do
  configure do |config|
    config.container = container
  end
end
