class Manager::ThemesController < Manager::BaseController
  before_action :authenticate_manager_restaurant_user!

  before_action :set_manager_theme, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_font_settings, only: [:create, :edit, :update, :new]

  before_action :set_restaurant

  def index
    @manager_themes = Theme.where(restaurant_id: @restaurant.id)
  end

  def show
    @manager_theme = Theme.find_by(restaurant_id: @restaurant.id)
  end

  def new
    @manager_theme = Theme.new
    @manager_theme.restaurant_id = @restaurant.id
  end

  def edit
  end

  def create
    @manager_theme = Theme.new(manager_theme_params)
    respond_to do |format|
      if @manager_theme.save
        format.html { redirect_to manager_restaurant_themes_path(@restaurant), notice: 'Restaurant theme was successfully created.' }
        format.json { render :show, status: :created, location: @manager_theme }
      else
        format.html { render :new }
        format.json { render json: @manager_theme.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @manager_theme.update(manager_theme_params)
        format.html { redirect_to manager_restaurant_themes_path(@restaurant), notice: 'Restauran theme was successfully updated.' }
        format.json { render :show, status: :ok, location: @manager_theme }
      else
        format.html { render :edit }
        format.json { render json: @manager_theme.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @manager_theme.destroy
    respond_to do |format|
      format.html { redirect_to manager_themes_url, notice: 'Restaurant theme was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_manager_theme
    if params[:id].present?
      @manager_theme = Theme.find(params[:id])
    else
      @manager_theme = Theme.find_by(restaurant_id: params[:restaurant_id])
    end
  end

  def set_font_settings
    @text_transforms = ['none', 'capitalize', 'uppercase', 'lowercase']
    @font_weights = [100,200,300,400,500,600,700,800,900]
    @font_styles = ['none', 'italic']
  end

  # Only allow a list of trusted parameters through.
  def manager_theme_params
    params.require(:theme).permit(
      :restaurant_id,
      :color_primary,
      :color_secondary,
      :css_font_url,
      :font_primary,
      :font_weight_primary,
      :text_transform_primary,
      :font_style_primary,
      :font_secondary,
      :font_weight_secondary,
      :text_transform_secondary,
      :font_style_secondary,
      :dark_theme,
      :custom_css
    )
  end

end
