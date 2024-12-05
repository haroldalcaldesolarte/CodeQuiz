require "application_system_test_case"

class GameResponsesTest < ApplicationSystemTestCase
  setup do
    @game_response = game_responses(:one)
  end

  test "visiting the index" do
    visit game_responses_url
    assert_selector "h1", text: "Game Responses"
  end

  test "creating a Game response" do
    visit game_responses_url
    click_on "New Game Response"

    check "Correct" if @game_response.correct
    fill_in "Game session", with: @game_response.game_session_id
    fill_in "Question", with: @game_response.question_id
    click_on "Create Game response"

    assert_text "Game response was successfully created"
    click_on "Back"
  end

  test "updating a Game response" do
    visit game_responses_url
    click_on "Edit", match: :first

    check "Correct" if @game_response.correct
    fill_in "Game session", with: @game_response.game_session_id
    fill_in "Question", with: @game_response.question_id
    click_on "Update Game response"

    assert_text "Game response was successfully updated"
    click_on "Back"
  end

  test "destroying a Game response" do
    visit game_responses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Game response was successfully destroyed"
  end
end
