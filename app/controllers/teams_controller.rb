class TeamsController < ApplicationController

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to teams_path, notice: 'Team successfully added'
    else
      redirect_to teams_path, notice: "Something went wrong, try again"
    end
  end

  def show
    @team = Team.find(params[:id])
    @team_ledgers = @team.ledgers
  end

  def destroy
    @team = Team.find(params[:id])
    if @team.destroy
      redirect_to teams_path, notice: 'Team successfully deleted'
    else
      redirect_to teams_path, notice: "Something went wrong, try again"
    end
  end

  def join
    @team = Team.find(params[:id])
    @team.join(current_user)
    redirect_to teams_path, notice: 'Joined team successfully'
  end

  def unjoin
    @team = Team.find(params[:id])
    @team.unjoin(current_user)
    redirect_to teams_path, notice: 'Unjoined team successfully'
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

end
