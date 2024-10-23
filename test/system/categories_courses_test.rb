require "application_system_test_case"

class CategoriesCoursesTest < ApplicationSystemTestCase
  setup do
    @categories_course = categories_courses(:one)
  end

  test "visiting the index" do
    visit categories_courses_url
    assert_selector "h1", text: "Categories Courses"
  end

  test "creating a Categories course" do
    visit categories_courses_url
    click_on "New Categories Course"

    fill_in "Category", with: @categories_course.category_id
    fill_in "Course", with: @categories_course.course_id
    click_on "Create Categories course"

    assert_text "Categories course was successfully created"
    click_on "Back"
  end

  test "updating a Categories course" do
    visit categories_courses_url
    click_on "Edit", match: :first

    fill_in "Category", with: @categories_course.category_id
    fill_in "Course", with: @categories_course.course_id
    click_on "Update Categories course"

    assert_text "Categories course was successfully updated"
    click_on "Back"
  end

  test "destroying a Categories course" do
    visit categories_courses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Categories course was successfully destroyed"
  end
end
