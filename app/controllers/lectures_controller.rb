class LecturesController < ApplicationController
  before_action :set_lecture, only: [:update, :destroy, :edit]

  def index
    @lectures = Lecture.all
  end

  def new
    @lecture = Lecture.new
  end

  def create
    @lecture = Lecture.new(lecture_params)
    if @lecture.save
      redirect_to lectures_path
    else
      render json: @lecture.errors, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @lecture.update(lecture_params)
      redirect_to lectures_path
    else
      render json: @lecture.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @lecture.destroy
    redirect_to lectures_path, notice: 'Palestra excluída com sucesso.'
  end

  def import
    uploaded_file = params[:file]

    if uploaded_file
      lines = uploaded_file.read.split("\n")
      organizer = ConferenceOrganizerService.new(lines)
      tracks = organizer.organize_tracks

      render plain: tracks.map { |track| track.to_s }.join("\n")
    else
      render json: { error: "No file provided" }, status: :unprocessable_entity
    end
  end

  private

  def set_lecture
    @lecture = Lecture.find(params[:id])
  end

  def lecture_params
    params.require(:lecture).permit(:name, :duration)
  end
end
