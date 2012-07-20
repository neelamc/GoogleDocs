#require 'google/api_client'

class OauthAuthorizationController < ApplicationController
  def index
    callback_url = url_for(:controller => "oauth_authorization", :action => "callback")
    begin
      @request_token = GoogleOauth.consumer.get_request_token({:oauth_callback => callback_url}, {:scope => 'https://docs.google.com/feeds'})
      if @request_token
        session[:request_token] = @request_token
        puts 'Redirect to authorize URL'
        redirect_to @request_token.authorize_url
      else
        flash[:error] = "Unable to contact Google. Try again."
        redirect_to root_path
      end
    rescue => e
      flash[:error] = "Unable to contact Google. Try again."
      redirect_to root_path
    end
  end


  def callback
    @request_token = session[:request_token]
    if @request_token.try(:secret)
      begin
        access_token = @request_token.get_access_token( {:oauth_verifier => params[:oauth_verifier]} )

        if access_token
          current_loggedin_user.update_attributes( :ga_access_token => access_token.token, :ga_access_secret => access_token.secret )
          puts "INSIDE CALLBACK - ACCESS TOKEN - IF"
          flash[:notice] = "Application successfully connected with Google Analytics user account."
          #redirect_to('/')
        end
      rescue => e
        flash[:error] = "Unable to connect with user account. Try again granting access to Google Analytics. (400)"
        redirect_to root_path
      end
    else
      flash[:error] = "Oops! Unable to connect with user account. Please, try again."
      redirect_to root_path
    end
   # session = Garb::Session.new
   #session.access_token = OAuth::AccessToken.new(GoogleOAuth.consumer, current_loggedin_user.access_token, current_loggedin_user.access_secret)
   #Garb::Management::Profile.all(session)
  end
end
