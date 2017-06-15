class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  def destroy
    return unless @attachment.is_author?(current_user)
    @attachment.destroy
  end

  private
    def load_attachment
      @attachment = Attachment.find(params[:id])
    end
end
