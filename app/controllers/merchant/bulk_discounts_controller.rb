class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
    holiday = HolidaySearch.new
    @holidays = holiday.next_three_holidays
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.new(bulk_discount_params.merge(merchant_id: @merchant.id))
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant), notice: "Discount successfully saved!"
    else
      flash.now[:alert] = "Error: #{error_message(bulk_discount.errors)}"
      render :new
    end
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    if @bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant,@bulk_discount), notice: "Bulk discount successfully updated!"
    else
      flash.now[:alert] = "Error: #{error_message(@bulk_discount.errors)}"
      render :edit
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(merchant)
  end
  
  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :quantity_threshold, :percentage_discount)
  end
end