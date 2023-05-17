class LotsController < ApplicationController
  include ActiveSupport::NumberHelper

  before_action :authenticate_admin!, only: [:new, :create, :update]

  def show
    @lot = Lot.find params[:id]
    @items = Item.where(lot_id: nil).or Item.where(lot_id: @lot.id)
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
    if @lot.waiting_approval? && @lot.creator != current_admin && @lot.update(status: params[:status])
      redirect_to lot_path(@lot.id), notice: 'Lote publicado com sucesso.'
    else
      redirect_to lot_path(@lot.id), notice: 'Status do lote não atualizado'
    end
  end

  private
  def lot_params
    params
      .require(:lot)
      .permit(:code, :initial_date, :limit_date, :minimum_bid, :minimum_bid_increment, item_ids: [])
  end
end
