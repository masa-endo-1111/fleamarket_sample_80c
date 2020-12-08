class PaysController < ApplicationController
  before_action :authenticate_user!
  require "payjp"

  def new
    card = Pay.where(user_id: current_user.id)
    # redirect_to action: "show" if card.exists?
  end

  def create #payjpとCardのデータベース作成を実施します。
    Payjp.api_key= Rails.application.credentials.payjp[:PAYJP_SECRET_KEY]
    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(
      # description: '登録テスト', #なくてもOK
      # email: current_user.email, #なくてもOK
      card: params['payjp-token'],
      metadata: {user_id: current_user.id}
      ) #念の為metadataにuser_idを入れましたがなくてもOK
      @card = Pay.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to pay_path(@card.id)
      else
        redirect_to action: "create"
      end
    end
  end

  def delete #PayjpとCardデータベースを削除します
    card = Pay.where(user_id: current_user.id).first
    if card.blank?
    else
      Payjp.api_key= Rails.application.credentials.payjp[:PAYJP_SECRET_KEY]
      customer = Payjp::Customer.retrieve(card.customer_id)
      customer.delete
      card.delete
    end
      redirect_to action: "new"
  end

  def show #Cardのデータpayjpに送り情報を取り出します
    card = Pay.where(user_id: current_user.id).first
    if card.blank?
      redirect_to action: "new" 
    else
      Payjp.api_key= Rails.application.credentials.payjp[:PAYJP_SECRET_KEY]
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end
end
