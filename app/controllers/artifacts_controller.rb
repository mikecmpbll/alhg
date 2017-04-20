class ArtifactsController < ApplicationController
  before_action :authenticate_user!

  def index
    @results = Artifact.search params[:search]
    @artifacts = @results.records if @results.respond_to? :records
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
    else
    end
  end

  def destroy
    @artifact = Artifact.find params[:id]

    if @artifact.destroy
    else
    end
  end

private
  def artifact_params
    params.require(:artifact).permit(:file, :file_cache)
  end
end
