class InfluencersController < ApplicationController
  def index
    @influencers = Influencer.all.page(params[:page]).per(100)
  end

  def new
    @import = Influencer::Import.new
    @influencer = Influencer.new
  end

  def import
    @influencer = Influencer.new
    @import = Influencer::Import.new(influencer_import_params)
    if @import.save
      flash[:success] =
        "Imported #{@import.imported_count}
        #{'influencer'.pluralize(@import.imported_count)}.
        Updated #{@import.updated_count}
        #{'influencer'.pluralize(@import.updated_count)}."
      redirect_to new_influencer_path
    else
      flash.now[:danger] = "There were errors with your CSV file.
      Imported #{@import.imported_count}
      #{'influencer'.pluralize(@import.imported_count)}.
      Updated #{@import.updated_count}
      #{'influencer'.pluralize(@import.updated_count)}."
      render new_influencer_path
    end
  end

  def create
    @influencer = Influencer.new(influencer_params)

    if @influencer.save(influencer_params)
      redirect_to edit_influencer_path(@influencer), notice: "Successfully created #{@influencer.full_name}."
    else
      @import = Influencer::Import.new
      render :new
    end
  end

  def search
    @query = params[:query].presence.try(:strip) || '*'
    if @query == '*'
      @influencers = Influencer.all.page(params[:page]).per(100)
    else
      @influencers = Influencer.search_by_email_or_last_name(@query)
                               .order('created_at DESC').page(params[:page]).per(100)
    end
  end

  def edit
    @influencer = Influencer.find(params[:id])
  end

  def update
    @influencer = Influencer.find(params[:id])

    if @influencer.update(influencer_params)
      redirect_to edit_influencer_path(@influencer), notice: "Successfully updated #{@influencer.full_name}."
    else
      render :edit
    end
  end

  private

  def influencer_import_params
    params.require(:influencer_import).permit(:file)
  end

  def influencer_params
    params.require(:influencer).permit(
      :first_name, :last_name, :active, :address1, :address2, :city, :state,
      :zip, :email, :phone, :bra_size, :top_size, :bottom_size, :sports_jacket_size,
      :collection_id
    )
  end
end
