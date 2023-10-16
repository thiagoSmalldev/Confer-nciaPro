require 'test_helper'

class LecturesHelperTest < ActionView::TestCase
  test "organize_tracks should return a hash of tracks" do
    lectures = [lecture_stub, lecture_stub]
    tracks = organize_tracks(lectures)
    assert_kind_of Hash, tracks
    assert_includes tracks, "Track A:"
    assert_includes tracks, "Track B:"
  end

  test "organize_track should return a hash of events for a track" do
    lectures = [lecture_stub, lecture_stub]
    track_name = "Track A:"
    track = organize_track(lectures, track_name)
    assert_kind_of Hash, track
    assert_includes track, track_name
    events = track[track_name]
    assert_kind_of Array, events
    assert events.all? { |event| event.is_a?(Hash) }
  end

  private

  def lecture_stub
    OpenStruct.new(
      name: "Sample Lecture",
      duration: "30min",
      id: 1
    )
  end
end
