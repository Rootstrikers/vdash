module Admin
  module Users
    class BansController < AdminController
      before_filter :get_user
      before_filter :get_ban, only: [:destroy]

      def index
        @bans = @user.bans
      end

      def new
        @ban = @user.bans.new
      end

      def create
        @ban = @user.bans.new(params[:ban])
        @ban.created_by = current_user
        if @ban.save
          redirect_to user_url(@user), flash: { success: 'User has been banned.' }
        else
          render :new
        end
      end

      def destroy
        @ban.update_attribute(:lifted_at, Time.now)
        redirect_to user_url(@user), flash: { success: 'User has been un-banned.' }
      end

      private
      def get_user
        @user = User.find(params[:user_id])
      end

      def get_ban
        @ban = @user.bans.find(params[:id])
      end
    end
  end
end
