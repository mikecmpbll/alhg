class ArtifactsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:search]
      @results = Artifact.search params[:search]
      @artifacts = @results.records
    else
      @results = []
      @artifacts = Artifact.all
    end
  end

  def show
    @artifact = Artifact.find params[:id]

    send_file @artifact.file.path
  end

  def new
    @artifact = Artifact.new
  end

  def create
    @artifact = Artifact.new artifact_params.merge creator: current_user

    if @artifact.save
      redirect_to artifacts_path, notice: t('artifacts.created')
    else
      render :new
    end
  end

  def edit
    @artifact = Artifact.find params[:id]
  end

  def update
    @artifact = Artifact.find params[:id]

    if @artifact.update artifact_params
      redirect_to artifacts_path,
        notice: t('artifacts.updated', artifact: @artifact.filename)
    else
      render :edit
    end
  end

  def destroy
    @artifact = Artifact.find params[:id]

    if @artifact.destroy
      redirect_to artifacts_path,
        notice: t('artifacts.destroyed', artifact: @artifact.filename)
    else
      redirect_to artifact_path(@artifact),
        alert: t('artifacts.error_destroying')
    end
  end

private
  def artifact_params
    params.require(:artifact).permit(
      :file,
      :file_cache,
      :filename,
      :description
    )
  end
end
