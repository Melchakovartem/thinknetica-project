require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message, status: 403 }
      format.js { render "partials/errors", locals: { error: exception.message }, status: 403 }
      format.json { render json: [exception.message], status: 403 }
    end
  end
end
