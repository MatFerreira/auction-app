class HomeController < ApplicationController
  include ActiveSupport::NumberHelper

  def index
    @ongoing_lots = Lot.where("status = 1 AND initial_date <= ? AND limit_date >= ?", Date.today, Date.today)
    @future_lots = Lot.where("status = 1 AND initial_date > ?", Date.today)
  end
end
