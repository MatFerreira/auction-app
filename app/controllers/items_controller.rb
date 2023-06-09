class ItemsController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :new, :create, :edit, :update, :destroy]

  def index
    @items = Item.all
  end

  def show
    @item = Item.find params[:id]
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to item_path(@item), notice: 'Item cadastrado com sucesso.'
    else
      flash.now.alert = 'O item não pôde ser cadastrado.'
      render :new
    end
  end

  def edit
    @item = Item.find params[:id]
  end

  def update
    @item = Item.find params[:id]
    if @item.update(item_params)
      redirect_to item_path(@item), notice: 'Item atualizado com sucesso.'
    else
      flash.now.alert = 'O item não pôde ser atualizado.'
      render :edit
    end
  end

  def destroy
    @item = Item.find params[:id]
    @item.destroy
    redirect_to items_path, notice: 'Item excluído com sucesso.'
  end

  private
  def item_params
    params
      .require(:item)
      .permit(:name, :description, :weight, :width, :height, :depth, :product_category, :picture)
  end
end
