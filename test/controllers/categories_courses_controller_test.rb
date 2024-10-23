require "test_helper"

class CategoriesCoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @categories_course = categories_courses(:one)
  end

  test "should get index" do
    get categories_courses_url
    assert_response :success
  end

  test "should get new" do
    get new_categories_course_url
    assert_response :success
  end

  test "should create categories_course" do
    assert_difference('CategoriesCourse.count') do
      post categories_courses_url, params: { categories_course: { category_id: @categories_course.category_id, course_id: @categories_course.course_id } }
    end

    assert_redirected_to categories_course_url(CategoriesCourse.last)
  end

  test "should show categories_course" do
    get categories_course_url(@categories_course)
    assert_response :success
  end

  test "should get edit" do
    get edit_categories_course_url(@categories_course)
    assert_response :success
  end

  test "should update categories_course" do
    patch categories_course_url(@categories_course), params: { categories_course: { category_id: @categories_course.category_id, course_id: @categories_course.course_id } }
    assert_redirected_to categories_course_url(@categories_course)
  end

  test "should destroy categories_course" do
    assert_difference('CategoriesCourse.count', -1) do
      delete categories_course_url(@categories_course)
    end

    assert_redirected_to categories_courses_url
  end
end
