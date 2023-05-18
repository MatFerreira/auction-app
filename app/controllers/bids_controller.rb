class BidsController < ApplicationController
  def create
    @bid = Bid.new(bid_params)
    if @bid.save
      redirect_to lot_path(@bid.lot_id), notice: 'Lance feito com sucesso.'
    else
      redirect_to lot_path(@bid.lot_id), alert: 'Lance inválido.'
    end
  end

  private
  def bid_params
    params
      .require(:bid)
      .permit(:value, :lot_id, :user_id)
  end
end
