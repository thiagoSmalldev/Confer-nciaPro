# app/helpers/lectures_helper.rb

module LecturesHelper
  def organize_tracks(lectures)
    track_a = organize_track(lectures, "Track A:")
    track_b = organize_track(lectures, "Track B:")

    tracks = track_a.merge(track_b)

    tracks
  end

  def organize_track(lectures, track_name)
    morning_start = Time.parse("09:00")
    lunch_start = Time.parse("12:00")
    lunch_end = Time.parse("13:00")
    afternoon_start = Time.parse("13:00")
    networking_start = Time.parse("16:00")
    end_time = Time.parse("17:00")

    current_time = morning_start
    morning_sessions = []
    lunch_added = false

    lectures.each do |lecture|
      name = lecture.name
      duration = lecture.duration
      duration_minutes = duration == "lightning" ? 5 : duration.to_i

      if current_time >= lunch_start && !lunch_added
        morning_sessions << { event: "12:00 Almoço", id: "lunch" }
        current_time = afternoon_start
        lunch_added = true
      elsif current_time >= networking_start
        morning_sessions << { event: "17:00 Evento de Networking", id: "Networking" }
        break
      end

      event_time = current_time.strftime('%H:%M')
      event = { event: "#{event_time} #{name} #{duration}min", id: lecture.id }

      morning_sessions << event
      current_time += duration_minutes * 60
    end

    track = {
      track_name => morning_sessions
    }

    track
  end
end
