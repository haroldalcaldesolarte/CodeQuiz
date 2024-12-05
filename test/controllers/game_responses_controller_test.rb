require "test_helper"

class GameResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_response = game_responses(:one)
  end

  test "should get index" do
    get game_responses_url
    assert_response :success
  end

  test "should get new" do
    get new_game_response_url
    assert_response :success
  end

  test "should create game_response" do
    assert_difference('GameResponse.count') do
      post game_responses_url, params: { game_response: { correct: @game_response.correct, game_session_id: @game_response.game_session_id, question_id: @game_response.question_id } }
    end

    assert_redirected_to game_response_url(GameResponse.last)
  end

  test "should show game_response" do
    get game_response_url(@game_response)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_response_url(@game_response)
    assert_response :success
  end

  test "should update game_response" do
    patch game_response_url(@game_response), params: { game_response: { correct: @game_response.correct, game_session_id: @game_response.game_session_id, question_id: @game_response.question_id } }
    assert_redirected_to game_response_url(@game_response)
  end

  test "should destroy game_response" do
    assert_difference('GameResponse.count', -1) do
      delete game_response_url(@game_response)
    end

    assert_redirected_to game_responses_url
  end
end
