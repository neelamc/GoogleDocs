class GoogleOauth < ActiveRecord::Base
  # attr_accessible :title, :body
  def self.consumer
    OAuth::Consumer.new(OAUTH_CREDENTIALS[:google][:key], OAUTH_CREDENTIALS[:google][:secret], {
      :site => 'https://www.google.com',
      :request_token_path => '/accounts/OAuthGetRequestToken',
      :access_token_path => '/accounts/OAuthGetAccessToken',
      :authorize_path => '/accounts/OAuthAuthorizeToken'
    })
  end
end
