Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'https://party-store-front-1dd4bbac1550.herokuapp.com'

      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        expose: ['Authorization'],
        credentials: true
    end
end
