class AccountMiddleware
  def initialize(app)
    @app = app
  end

  # http://example.com/12345/projects
  def call(env)
    _, account_id, request_path = env["REQUEST_PATH"].split('/', 3)

    if account_id =~ /\d+/
      Current.account = Account.find(account_id)

      env["SCRIPT_NAME"]  = "/#{account_id}"
      env["PATH_INFO"]    = "/#{request_path}"
      env["REQUEST_PATH"] = "/#{request_path}"
      env["REQUEST_URI"]  = "/#{request_path}"
    end

    status, headers, body = @app.call(env)
    [status, headers, body]
  end
end
