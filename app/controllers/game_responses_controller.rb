class GameResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user!
  before_action :set_game_response, only: %i[ show edit update destroy ]

  # GET /game_responses or /game_responses.json
  def index
    @game_responses = GameResponse.all
  end

  # GET /game_responses/1 or /game_responses/1.json
  def show
  end

  # GET /game_responses/new
  def new
    @game_response = GameResponse.new
  end

  # GET /game_responses/1/edit
  def edit
  end

  # POST /game_responses or /game_responses.json
  def create
    @game_response = GameResponse.new(game_response_params)

    respond_to do |format|
      if @game_response.save
        format.html { redirect_to @game_response, notice: "Game response was successfully created." }
        format.json { render :show, status: :created, location: @game_response }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_responses/1 or /game_responses/1.json
  def update
    respond_to do |format|
      if @game_response.update(game_response_params)
        format.html { redirect_to @game_response, notice: "Game response was successfully updated." }
        format.json { render :show, status: :ok, location: @game_response }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_responses/1 or /game_responses/1.json
  def destroy
    @game_response.destroy

    respond_to do |format|
      format.html { redirect_to game_responses_path, status: :see_other, notice: "Game response was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_response
      @game_response = GameResponse.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_response_params
      params.require(:game_response).permit(:game_session_id, :question_id, :correct)
    end
end
