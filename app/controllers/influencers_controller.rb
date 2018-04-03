class InfluencersController < ApplicationController
  def index
  end

  def new
    @import = Influencer::Import.new
  end

  def import
    @import = Influencer::Import.new(influencer_import_params)
    if @import.save
      flash[:success] = "Imported #{@import.imported_count} #{'influencer'.pluralize(@import.imported_count)}."
      redirect_to new_influencer_path
    else
      flash.now[:danger] = "There were errors with your CSV file. Imported #{@import.imported_count} #{'influencer'.pluralize(@import.imported_count)}."
      render new_influencer_path
    end
  end

  private

  def influencer_import_params
    params.require(:influencer_import).permit(:file)
  end
end
