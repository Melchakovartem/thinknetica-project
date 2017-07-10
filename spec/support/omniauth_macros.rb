module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      'provider' => provider.to_s,
      'uid' => '1235456',
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    }.merge(provider == :facebook ? {info: {email: 'test@test.com.ru'}} : {}))
  end
end
