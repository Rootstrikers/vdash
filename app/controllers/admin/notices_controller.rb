module Admin
  class NoticesController < AdminController
    before_filter :get_notice, only: [:edit, :update, :destroy]

    def index
      @notices = Notice.order('id desc').paginate(page: params[:page])
    end

    def new
      @notice = Notice.new
    end

    def create
      @notice = current_user.notices.new(params[:notice])
      if @notice.save
        redirect_to admin_notices_url, flash: { success: 'Notice created.' }
      else
        render :new
      end
    end

    def edit; end

    def update
      if @notice.update_attributes(params[:notice])
        redirect_to admin_notices_url, flash: { success: 'Notice updated.' }
      else
        render :edit
      end
    end

    def destroy
      @notice.destroy
      redirect_to admin_notices_url, flash: { success: 'Notice deleted.' }
    end

    private
    def get_notice
      @notice = current_user.notices.find(params[:id])
    end
  end
end
