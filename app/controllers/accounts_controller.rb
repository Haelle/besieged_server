class AccountsController < ApplicationController
  # allow access without tokens only for create action
  before_action :authorize_access_request!, only: %i[show update destroy]
  before_action :set_account, only: %i[show update destroy]
  before_action :authorize_action_only_on_itself!, only: %i[show update destroy]

  # GET /accounts/1
  def show
    render json: AccountBlueprint.render(@account)
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)

    if @account.save
      render json: AccountBlueprint.render(@account), status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update_with_password(account_params)
      render json: AccountBlueprint.render(@account)
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def account_params
    params.require(:account).permit(:email, :password, :current_password)
  end

  def authorize_action_only_on_itself!
    raise Unauthorized unless @account.id == found_account.id
  end
end
