class Admin::UsersController < ApplicationController
  layout "admin"

  helper_method :administrators, :customers
  def administrators
    @administrators ||= User.where(is_admin: true)
  end

  def customers
    @customers ||= User.where(is_admin: false)
  end

  def new
    admin = request.referer.split("/").last == "administrators" ? 1 : 0
    @user = User.new(is_admin: admin)
  end

  def show
    @user = User.find(params[:id])
    
  end

  def create
    
    @user = User.new(params[:user].permit(:first_name, :last_name, :email, :phone, :address, :is_admin, :company, :password, :password_confirmation))
 
    respond_to do |format|
      if @user.save
        if @user.is_admin
          format.html { redirect_to(administrators_admin_users_path, notice: 'Se guardó satisfactoriamente.') }
        else
          format.html { redirect_to(customers_admin_users_path, notice: 'Se guardó satisfactoriamente.') }
        end
      else
        format.html { render action: 'new' }
      end
    end 
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(params[:user].permit(:first_name, :last_name, :email, :phone, :address, :company))
      user.is_admin ? redirect_to(administrators_admin_users_path) : redirect_to(customers_admin_users_path)
    else
      redirect_to edit_admin_user_path
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render layout: nil
  end
end
