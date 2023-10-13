class LectureService
  def initialize(name, duration)
    @name = name
    @duration = duration
  end

  def create_lecture
    @name = @name.force_encoding("UTF-8") if @name.respond_to?(:force_encoding)

    lecture = Lecture.new(name: @name, duration: @duration)

    if lecture.save
      lecture
    else
      nil
    end
  end
end
