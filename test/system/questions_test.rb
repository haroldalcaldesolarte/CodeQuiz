require "application_system_test_case"

class QuestionsTest < ApplicationSystemTestCase
  setup do
    @question = questions(:one)
  end

  test "visiting the index" do
    visit questions_url
    assert_selector "h1", text: "Questions"
  end

  test "creating a Question" do
    visit questions_url
    click_on "New Question"

    check "Approved" if @question.approved
    fill_in "Author", with: @question.author_id
    fill_in "Category", with: @question.category_id
    fill_in "Level", with: @question.level_id
    fill_in "Question text", with: @question.question_text
    fill_in "Revisor", with: @question.revisor_id
    click_on "Create Question"

    assert_text "Question was successfully created"
    click_on "Back"
  end

  test "updating a Question" do
    visit questions_url
    click_on "Edit", match: :first

    check "Approved" if @question.approved
    fill_in "Author", with: @question.author_id
    fill_in "Category", with: @question.category_id
    fill_in "Level", with: @question.level_id
    fill_in "Question text", with: @question.question_text
    fill_in "Revisor", with: @question.revisor_id
    click_on "Update Question"

    assert_text "Question was successfully updated"
    click_on "Back"
  end

  test "destroying a Question" do
    visit questions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Question was successfully destroyed"
  end
end
