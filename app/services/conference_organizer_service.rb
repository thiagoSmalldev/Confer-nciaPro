class ConferenceOrganizerService
  def initialize(lines)
    @lines = lines
  end

  def organize_tracks
    morning_track = { name: 'Track A:', sessions: [] }
    afternoon_track = { name: 'Track B:', sessions: [] }
    morning_start = Time.parse("09:00")
    lunch = Time.parse("12:00")
    afternoon_start = Time.parse("13:00")
    networking_start = Time.parse("16:00")

    current_time = morning_start
    last_session = nil

    @lines.each do |line|
      next if line.blank?

      name, duration = extract_name_and_duration(line)
      name = remove_numbers(name)
      duration = extract_integer(duration)

      next_time = duration_in_minutes(duration, current_time)

      if current_time >= lunch
        morning_track[:sessions].last[:events] << "Almoço"
        current_time = afternoon_start
      elsif current_time >= networking_start
        afternoon_track[:sessions].last[:events] << "Evento de Networking"
        current_time = morning_start
      end

      current_time_str = current_time.strftime('%H:%M')

      event = "#{current_time_str} #{name} #{duration}min"

      lacture = LectureService.new(name, duration)
      lacture.create_lecture

      if current_time < lunch
        morning_track[:sessions] << { time: current_time, events: [event] }
        last_session = morning_track[:sessions].last
      else
        afternoon_track[:sessions] << { time: current_time, events: [event] }
        last_session = afternoon_track[:sessions].last
      end

      current_time = duration_in_minutes(duration, current_time)

      # Certifique-se de que a próxima palestra comece após as 17h
      if current_time >= networking_start
        current_time = morning_start
        afternoon_track[:sessions].delete(last_session)
      end
    end

    # morning_track[:sessions].last[:events] << "Almoço" if current_time < lunch
    afternoon_track[:sessions].last[:events] << "Evento de Networking" if current_time >= networking_start

    [morning_track, afternoon_track]
  end

  private

  def extract_name_and_duration(line)
    match_data = line.match(/^(.+) (\d+min|lightning)$/)
    if match_data
      match_data.captures
    else
      [nil, nil]  # Retorna valores nulos se não houver correspondência
    end
  end

  def remove_numbers(name)
    name.gsub(/\d/, "") if name  # Remove todos os dígitos do nome
  end

  def extract_integer(duration)
    duration == "lightning" ? 5 : duration.to_i
  end

  def format_event(time, name, duration)
    "#{time.strftime('%H:%M')} #{name} #{duration}min"
  end

  def duration_in_minutes(duration, current_time)
    duration_minutes = duration == "lightning" ? 5 : duration.to_i
    current_time + duration_minutes * 60
  end

  def session_full?(session, session_end)
    session && session[:time] >= session_end
  end

  def add_minutes_to_time(time_str, minutes_to_add)
    time = Time.parse(time_str)
    new_time = time + minutes_to_add * 60
    new_time.strftime('%H:%M')
  end
end
