class LotsController < ApplicationController
  include ActiveSupport::NumberHelper

  before_action :authenticate_admin!, only: [:index, :new, :create, :update]
  before_action :authenticate_user!, only: [:owned]

  def index
    @bid_lots = Lot.joins(:bids).where('lots.status = 1 AND lots.limit_date < ?', Date.today).distinct
    @bidless_lots = Lot.left_outer_joins(:bids).where('lots.status = 1 AND lots.limit_date < ? AND bids.id IS NULL', Date.today)
  end

  def show
    @lot = Lot.find params[:id]
    @items = Item.where(lot_id: nil).or Item.where(lot_id: @lot.id)
    @highest_bid = Bid.where(lot_id: @lot.id).order(value: :desc).first
  end

  def new
    @lot = Lot.new
  end

  def create
    @lot = Lot.new(lot_params)
    @lot.creator = current_admin
    if @lot.save
      redirect_to lot_path(@lot.id), notice: 'Lote cadastrado com sucesso.'
    else
      flash.now.alert = 'Não foi possível cadastrar o lote.'
      render :new
    end
  end

  def update
    @lot = Lot.find params[:id]
    if @lot.waiting_approval? && @lot.update(lot_params)
      redirect_to lot_path(@lot.id), notice: 'Lote atualizado com sucesso.'
    else
      redirect_to lot_path(@lot.id), alert: 'Não foi possível atualizar o lote.'
    end
  end

  def update_status
    @lot = Lot.find params[:id]
    new_status = params[:status]
    if @lot.waiting_approval? && @lot.creator != current_admin && new_status == 'published'
      flash.notice = 'Lote publicado com sucesso.'
    elsif @lot.published? && new_status == 'closed'
      flash.notice = 'Lote encerrado com sucesso.'
    elsif @lot.published? && new_status == 'canceled'
      flash.notice = 'Lote cancelado com sucesso.'
    else
      redirect_to lots_path, alert: 'Status do lote não atualizado'
    end
    @lot.update(status: new_status)
    redirect_to lots_path
  end

  def owned
    @owned_lots = Lot.joins(:bids)
      .where(status: 2)
      .where('bids.user_id = ?', current_user.id)
      .where('bids.value = (SELECT MAX(value) FROM bids WHERE bids.lot_id = lots.id)')
  end

  private
  def lot_params
    params
      .require(:lot)
      .permit(:code, :initial_date, :limit_date, :minimum_bid, :minimum_bid_increment, item_ids: [])
  end
end
