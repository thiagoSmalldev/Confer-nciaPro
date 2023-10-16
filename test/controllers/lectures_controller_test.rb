require 'test_helper'

class LecturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lecture = lectures(:one)
  end

  test "should get index" do
    get lectures_url
    assert_response :success
  end

  test "should get new" do
    get new_lecture_url
    assert_response :success
  end

  test "should create lecture" do
    assert_difference('Lecture.count') do
      post lectures_url, params: { lecture: { name: "New Lecture", duration: 45 } }
    end

    assert_redirected_to lectures_url
  end

  test "should get edit" do
    get edit_lecture_url(@lecture)
    assert_response :success
  end

  test "should update lecture" do
    patch lecture_url(@lecture), params: { lecture: { name: "Updated Lecture" } }
    assert_redirected_to lectures_url
  end

  test "should destroy lecture" do
    assert_difference('Lecture.count', -1) do
      delete lecture_url(@lecture)
    end

    assert_redirected_to lectures_url
  end

  test "should import lectures" do
    file = fixture_file_upload('test/fixtures/files/entrada.txt', 'text/plain')
    post import_lectures_url, params: { file: file }
    assert_response :success
  end
end
